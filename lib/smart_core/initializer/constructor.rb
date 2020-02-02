# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Constructor
  require_relative 'constructor/definer'

  # @param klass [Class<SmartCore::Initializer>]
  # @param arguments [Array<Any>]
  # @param block [Proc, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(klass, arguments, block)
    @klass = klass
    @arguments = arguments
    @parameters, @options = extract_attributes(arguments)
    @block = block
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def construct
    allocate_klass_instance.tap do |instance|
      prevent_attribute_insufficiency
      initialize_parameters(instance)
      initialize_options(instance)
      process_original_initializer(instance)
      process_init_extensions(instance)
    end
  end

  private

  # @return [Class]
  #
  # @api private
  # @since 0.1.0
  attr_reader :klass

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :arguments

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :parameters

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :options

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :block

  # @return [void]
  #
  # @raise [SmartCore::Initializer::ParameterArgumentError]
  # @raise [SmartCore::Initializer::OptionArgumentError]
  #
  # @api private
  # @since 0.1.0
  def prevent_attribute_insufficiency
    required_options = klass.__options__.reject(&:has_default?).map(&:name)
    required_parameter_count = klass.__params__.size

    raise(
      SmartCore::Initializer::ParameterArgumentError,
      "Wrong number of parameters " \
      "(given #{parameters.size}, expected #{required_parameter_count})"
    ) unless parameters.size == required_parameter_count

    missing_options = required_options.reject { |option| options.key?(option) }

    raise(
      SmartCore::Initializer::OptionArgumentError,
      "Missing options: #{missing_options.join(', ')}"
    ) if missing_options.any?
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def allocate_klass_instance
    klass.allocate
  end

  # @param instance [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize_parameters(instance)
    parameter_definitions = Hash[klass.__params__.zip(parameters)]

    parameter_definitions.each_pair do |attribute, parameter_value|
      parameter_value = attribute.type.cast(parameter_value) if attribute.cast?

      # TODO: fail with SmartCore::Initializer::ArgumentError
      #   (isntead of SmartCore::Types::TypeError)
      attribute.type.validate!(parameter_value)

      final_value = attribute.finalizer.call(parameter_value, instance)
      instance.instance_variable_set("@#{attribute.name}", final_value)
    end
  end

  # @param instance [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize_options(instance)
    klass.__options__.each do |attribute|
      option_value = options.fetch(attribute.name) { attribute.default }
      option_value = attribute.type.cast(option_value) if attribute.cast?

      # TODO: fail with SmartCore::Initializer::ArgumentError
      #   (isntead of SmartCore::Types::TypeError)
      attribute.type.validate!(option_value)

      final_value = attribute.finalizer.call(option_value, instance)
      instance.instance_variable_set("@#{attribute.name}", final_value)
    end
  end

  # @param instance [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_original_initializer(instance)
    instance.send(:initialize, *arguments, &block)
  end

  # @param instance [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def process_init_extensions(instance)
    klass.__init_extensions__.each do |extension|
      extension.call(instance)
    end
  end

  # @param arguments [Array<Any>]
  # @return [Array<Array<Any>,Hash<Symbol,Any>>]
  #
  # @api private
  # @since 0.1.0
  def extract_attributes(arguments)
    extracted_parameters = []
    extracted_options = {}

    if (
      klass.__options__.size >= 1 &&
      arguments.last.is_a?(Hash) &&
      arguments.last.keys.all? { |key| key.is_a?(Symbol) }
    )
      extracted_parameters = arguments[0..-2]
      extracted_options = arguments.last
    else
      extracted_parameters = arguments
    end

    [extracted_parameters, extracted_options]
  end
end
