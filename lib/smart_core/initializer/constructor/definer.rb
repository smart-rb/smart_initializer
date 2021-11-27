# frozen_string_literal: true

# @api private
# @since 0.1.0
# rubocop:disable Metrics/ClassLength
class SmartCore::Initializer::Constructor::Definer
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
  def define_init_extension(block)
    thread_safe do
      add_init_extension(build_init_extension(block))
    end
  end

  # @param name [String, Symbol]
  # @param type [String, Symbol, Any]
  # @param type_system [String, Symbol]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param mutable [Boolean]
  # @param as [String, Symbol, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_parameter(
    name,
    type,
    type_system,
    privacy,
    finalize,
    cast,
    mutable,
    as
  )
    thread_safe do
      attribute = build_param_attribute(
        name,
        type,
        type_system,
        privacy,
        finalize,
        cast,
        mutable,
        as
      )
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
        build_param_attribute(
          name,
          klass.__initializer_settings__.generic_type_object,
          klass.__initializer_settings__.type_system,
          SmartCore::Initializer::Attribute::Value::Param::DEFAULT_PRIVACY_MODE,
          SmartCore::Initializer::Attribute::Value::Param::DEFAULT_FINALIZER,
          SmartCore::Initializer::Attribute::Value::Param::DEFAULT_CAST_BEHAVIOUR,
          SmartCore::Initializer::Attribute::Value::Param::DEFAULT_MUTABLE,
          SmartCore::Initializer::Attribute::Value::Param::DEFAULT_AS
        ).tap do |attribute|
          prevent_option_overlap(attribute)
        end
      end.each do |attribute|
        add_parameter(attribute)
      end
    end
  end

  # @param name [String, Symbol]
  # @param type [String, Symbol, Any]
  # @param type_system [String, Symbol]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param mutable [Boolean]
  # @param as [String, Symbol, NilClass]
  # @param default [Proc, Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_option(
    name,
    type,
    type_system,
    privacy,
    finalize,
    cast,
    mutable,
    as,
    default
  )
    thread_safe do
      attribute = build_option_attribute(
        name,
        type,
        type_system,
        privacy,
        finalize,
        cast,
        mutable,
        as,
        default
      )
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
        build_option_attribute(
          name,
          klass.__initializer_settings__.generic_type_object,
          klass.__initializer_settings__.type_system,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_PRIVACY_MODE,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_FINALIZER,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_CAST_BEHAVIOUR,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_MUTABLE,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_AS,
          SmartCore::Initializer::Attribute::Value::Option::UNDEFINED_DEFAULT
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
  # @param type [String, Symbol, Any]
  # @param type_system [String, Symbol]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param mutable [Boolean]
  # @param as [String, Symbol, NilClass]
  # @return [SmartCore::Initializer::Attribute::Value::Param]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def build_param_attribute(
    name,
    type,
    type_system,
    privacy,
    finalize,
    cast,
    mutable,
    as
  )
    SmartCore::Initializer::Attribute::Factory::Param.create(
      name, type, type_system, privacy, finalize, cast, mutable, as
    )
  end

  # @param name [String, Symbol]
  # @param type [String, Symbol, Any]
  # @param type_system [String, Symbol]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param mutable [Boolean]
  # @param as [String, Symbol, NilClass]
  # @param default [Proc, Any]
  # @return [SmartCore::Initializer::Attribute::Value::Option]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def build_option_attribute(
    name,
    type,
    type_system,
    privacy,
    finalize,
    cast,
    mutable,
    as,
    default
  )
    SmartCore::Initializer::Attribute::Factory::Option.create(
      name, type, type_system, privacy, finalize, cast, mutable, as, default
    )
  end

  # @param block [Proc]
  # @return [SmartCore::Initializer::Extensions::ExtInit]
  #
  # @api private
  # @since 0.1.0
  def build_init_extension(block)
    SmartCore::Initializer::Extensions::ExtInit.new(block)
  end

  # @param parameter [SmartCore::Initializer::Attribute::Value::Param]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_parameter(parameter)
    klass.__params__ << parameter
    klass.send(:attr_reader, parameter.name)
    klass.send(:attr_writer, parameter.name) if parameter.mutable?
    klass.send(:alias_method, parameter.name, parameter.as) if parameter.as
    klass.send(parameter.privacy, parameter.name)
  end

  # @param option [SmartCore::Initializer::Attribute::Value::Option]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_option(option)
    klass.__options__ << option
    klass.send(:attr_reader, option.name)
    klass.send(:attr_writer, option.name) if option.mutable?
    klass.send(:alias_method, option.name, option.as) if option.as
    klass.send(option.privacy, option.name)
  end

  # @param extension [SmartCore::Initializer::Extensions::ExtInit]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_init_extension(extension)
    klass.__init_extensions__ << extension
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
# rubocop:enable Metrics/ClassLength
