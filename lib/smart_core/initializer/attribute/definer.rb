# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Definer
  # @param klass [Class]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(klass)
    @klass = klass
    @lock = SmartCore::Engine::Lock.new
  end

  # @param block [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_init_extention(block)

  end

  # @param name [String, Symbol]
  # @param type [String, Symbol, SmartCore::Types::Primitive]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_parameter(name, type, privacy, finalize, cast, dynamic_options)
    thread_safe do
      attribute = build_attribute(name, type, privacy, finalize, cast, dynamic_options)
      prevent_option_overlap(attribute)
      add_parameter(attribute)
    end
  end

  # @param names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_parameters(*names)
    thread_safe do
      names.map do |name|
        build_attribute(
          name,
          SmartCore::Types::Value::Any,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_PRIVACY_MODE,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_FINALIZER,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_CAST_BEHAVIOUR,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_DYNAMIC_OPTIONS.dup
        ).tap do |attribute|
          prevent_option_overlap(attribute)
        end
      end.each do |attribute|
        add_parameter(attribute)
      end
    end
  end

  # @param name [String, Symbol]
  # @param type [String, Symbol, SmartCore::Types::Primitive]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_option(name, type, privacy, finalize, cast, dynamic_options)
    thread_safe do
      attribute = build_attribute(name, type, privacy, finalize, cast, dynamic_options)
      prevent_parameter_overlap(attribute)
      add_option(attribute)
    end
  end

  # @param names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_options(*names)
    thread_safe do
      names.map do |name|
        build_attribute(
          name,
          SmartCore::Types::Value::Any,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_PRIVACY_MODE,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_FINALIZER,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_CAST_BEHAVIOUR,
          SmartCore::Initializer::Attribute::Parameters::DEFAULT_DYNAMIC_OPTIONS.dup
        ).tap do |attribute|
          prevent_parameter_overlap(attribute)
        end
      end.each do |attribute|
        add_option(attribute)
      end
    end
  end

  private

  # @return [Class]
  #
  # @api private
  # @since 0.1.0
  attr_reader :klass

  # @param name [String, Symbol]
  # @param type [String, Symbol, SmartCore::Types::Primitive]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [SmartCore::Initializer::Attribute]
  #
  # @api private
  # @since 0.1.0
  def build_attribute(name, type, privacy, finalize, cast, dynamic_options)
    SmartCore::Initializer::Attribute::Factory.create(
      name, type, privacy, finalize, cast, dynamic_options
    )
  end

  # @param parameter [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_parameter(parameter)
    klass.__params__ << parameter
    klass.send(:attr_reader, parameter.name)
    klass.send(parameter.privacy, parameter.name)
  end

  # @param option [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_option(option)
    klass.__options__ << option
    klass.send(:attr_reader, option.name)
    klass.send(option.privacy, option.name)
  end

  # @param parameter [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def prevent_option_overlap(parameter)
    if klass.__options__.include?(parameter)
      raise(SmartCore::Initializer::OptionOverlapError, <<~ERROR_MESSAGE)
        You have already defined option with name :#{parameter.name}
      ERROR_MESSAGE
    end
  end

  # @param option [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def prevent_parameter_overlap(option)
    if klass.__params__.include?(option)
      raise(SmartCore::Initializer::ParameterOverlapError, <<~ERROR_MESSAGE)
        You have already defined parameter with name :#{option.name}
      ERROR_MESSAGE
    end
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
