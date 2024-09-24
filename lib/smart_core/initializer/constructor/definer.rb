# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.10.0
# rubocop:disable Metrics/ClassLength
class SmartCore::Initializer::Constructor::Definer
  # @param klass [Class]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def initialize(klass)
    @klass = klass
    @lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @param block [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def define_init_extension(block)
    @lock.write_sync do
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
  # @version 0.10.0
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
    @lock.write_sync do
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
  # @option mutable [Boolean]
  # @option privacy [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def define_parameters(*names, mutable:, privacy:)
    @lock.write_sync do
      names.map do |name|
        build_param_attribute(
          name,
          klass.__initializer_settings__.generic_type_object,
          klass.__initializer_settings__.type_system,
          privacy,
          SmartCore::Initializer::Attribute::Value::Param::DEFAULT_FINALIZER,
          klass.__initializer_settings__.auto_cast,
          mutable,
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
  # @param optional [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def define_option(
    name,
    type,
    type_system,
    privacy,
    finalize,
    cast,
    mutable,
    as,
    default,
    optional
  )
    @lock.write_sync do
      attribute = build_option_attribute(
        name,
        type,
        type_system,
        privacy,
        finalize,
        cast,
        mutable,
        as,
        default,
        optional
      )
      prevent_parameter_overlap(attribute)
      add_option(attribute)
    end
  end

  # @param names [Array<String, Symbol>]
  # @option mutable [Boolean]
  # @option privacy [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def define_options(*names, mutable:, privacy:)
    @lock.write_sync do
      names.map do |name|
        build_option_attribute(
          name,
          klass.__initializer_settings__.generic_type_object,
          klass.__initializer_settings__.type_system,
          privacy,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_FINALIZER,
          klass.__initializer_settings__.auto_cast,
          mutable,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_AS,
          SmartCore::Initializer::Attribute::Value::Option::UNDEFINED_DEFAULT,
          SmartCore::Initializer::Attribute::Value::Option::DEFAULT_OPTIONAL
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
      klass, name, type, type_system, privacy, finalize, cast, mutable, as
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
  # @param optional [Boolean]
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
    default,
    optional
  )
    SmartCore::Initializer::Attribute::Factory::Option.create(
      klass, name, type, type_system, privacy, finalize, cast, mutable, as, default, optional
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
  # @version 0.8.0
  # rubocop:disable Metrics/AbcSize
  def add_parameter(parameter)
    klass.__params__ << parameter
    klass.__send__(:attr_reader, parameter.name)
    klass.__send__(parameter.privacy, parameter.name)

    if parameter.mutable?
      # NOTE:
      #   code evaluation approach is used instead of `define_method` approach in order
      #   to avoid the `clojure`-context binding inside the new method (this context can
      #   access the current context or the current variable set and the way to avoid this by
      #   ruby method is more diffcult to support and read insead of the real `code` evaluation)
      klass.class_eval(<<~METHOD_CODE, __FILE__, __LINE__ + 1)
        #{parameter.privacy} def #{parameter.name}=(new_value)
          self.class.__params__[:#{parameter.name}].validate!(new_value)
          @#{parameter.name} = new_value
        end
      METHOD_CODE
    end

    if parameter.as
      klass.__send__(:alias_method, parameter.as, parameter.name)
      klass.__send__(:alias_method, "#{parameter.as}=", "#{parameter.name}=") if parameter.mutable?

      klass.__send__(parameter.privacy, parameter.as)
      klass.__send__(parameter.privacy, "#{parameter.as}=") if parameter.mutable?
    end
  end
  # rubocop:enable Metrics/AbcSize

  # @param option [SmartCore::Initializer::Attribute::Value::Option]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  # rubocop:disable Metrics/AbcSize
  def add_option(option)
    klass.__options__ << option
    klass.__send__(:attr_reader, option.name)
    klass.__send__(option.privacy, option.name)

    if option.mutable?
      # NOTE:
      #   code evaluation approach is used instead of `define_method` approach in order
      #   to avoid the `clojure`-context binding inside the new method (this context can
      #   access the current context or the current variable set and the way to avoid this by
      #   ruby method is more diffcult to support and read insead of the real `code` evaluation)
      klass.class_eval(<<~METHOD_CODE, __FILE__, __LINE__ + 1)
        #{option.privacy} def #{option.name}=(new_value)
          self.class.__options__[:#{option.name}].validate!(new_value)
          @#{option.name} = new_value
        end
      METHOD_CODE
    end

    if option.as
      klass.__send__(:alias_method, option.as, option.name)
      klass.__send__(:alias_method, "#{option.as}=", "#{option.name}=") if option.mutable?

      klass.__send__(option.privacy, option.as)
      klass.__send__(option.privacy, "#{option.as}=") if option.mutable?
    end
  end
  # rubocop:enable Metrics/AbcSize

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
end
# rubocop:enable Metrics/ClassLength
