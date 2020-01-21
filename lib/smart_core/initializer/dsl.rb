# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::DSL
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_eval do
        instance_variable_set(:@__params__,  SmartCore::Initializer::Attribute::List.new)
        instance_variable_set(:@__options__, SmartCore::Initializer::Attribute::List.new)
        instance_variable_set(:@__definer__, SmartCore::Initializer::Attribute::Definer.new(self))
      end

      base_klass.extend(ClassMethods)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [SmartCore::Initializer::Attribute::List]
    #
    # @api private
    # @since 0.1.0
    def __params__
      @__params__
    end

    # @return [SmartCore::Initializer::Attribute::List]
    #
    # @api private
    # @since 0.1.0
    def __options__
      @__options__
    end

    # @return [SmartCore::Initializer::Attribute::Definer]
    #
    # @api private
    # @since 0.1.0
    def __definer__
      @__definer__
    end

    # @param name [String, Symbol]
    # @param type [String, Symbol, SmartCore::Types::Primitive]
    # @option cast [Boolean]
    # @option privacy [String, Symbol]
    # @option finalize [String, Symbol, Proc]
    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def param(
      name,
      type = SmartCore::Types::Value::Any,
      privacy: SmartCore::Initializer::Attribute::Parameters::DEFAULT_PRIVACY_MODE,
      finalize: SmartCore::Initializer::Attribute::Parameters::DEFAULT_FINALIZER,
      cast: SmartCore::Initializer::Attribute::Parameters::DEFAULT_CAST_BEHAVIOUR,
      **dynamic_options
    )
      __definer__.define_parameter(name, type, privacy, finalize, cast, dynamic_options)
    end

    # @param names [Array<String, Symbol>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def params(*names)
      __definer__.define_parameters(*names)
    end

    # @param name [String, Symbol]
    # @param type [String, Symbol, SmartCore::Types::Primitive]
    # @option cast [Boolean]
    # @option privacy [String, Symbol]
    # @option finalize [String, Symbol, Proc]
    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def option(
      name,
      type = SmartCore::Types::Value::Any,
      privacy: SmartCore::Initializer::Attribute::Parameters::DEFAULT_PRIVACY_MODE,
      finalize: SmartCore::Initializer::Attribute::Parameters::DEFAULT_FINALIZER,
      cast: SmartCore::Initializer::Attribute::Parameters::DEFAULT_CAST_BEHAVIOUR,
      **dynamic_options
    )
      __definer__.define_option(name, type, privacy, finalize, cast, dynamic_options)
    end

    # @param names [Array<String, Symbol>]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def options(*names)
      __definer__.define_options(*names)
    end
  end
end
