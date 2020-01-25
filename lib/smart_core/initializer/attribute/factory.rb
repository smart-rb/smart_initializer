# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Factory
  class << self
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
    def create(name, type, privacy, finalize, cast, dynamic_options)
      name            = prepare_name_param(name)
      type            = prepare_type_param(type)
      privacy         = prepare_privacy_param(privacy)
      finalize        = prepare_finalize_param(finalize)
      cast            = prepare_cast_param(cast)
      dynamic_options = prepare_dynamic_options_param(dynamic_options)

      create_attribute(name, type, privacy, finalize, cast, dynamic_options)
    end

    private

    # @param name [String, Symbol]
    # @return [Symbol]
    #
    # @api private
    # @since 0.1.0
    def prepare_name_param(name)
      unless name.is_a?(String) || name.is_a?(Symbol)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute name should be a type of String or Symbol
        ERROR_MESSAGE
      end

      name.to_sym
    end

    # @param type [String, Symbol, SmartCore::Types::Primitive]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    def prepare_type_param(type)
      unless type.is_a?(String) || type.is_a?(Symbol) || type.is_a?(SmartCore::Types::Primitive)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute type should be a type of String, Symbol or SmartCore::Types::Primitive
        ERROR_MESSAGE
      end

      if type.is_a?(String) || type.is_a?(Symbol)
        SmartCore::Initializer.type_from_alias(type)
      else
        type
      end
    end

    # @param cast [Boolean]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def prepare_cast_param(cast)
      unless cast.is_a?(TrueClass) || cast.is_a?(FalseClass)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute cast should be a type of boolean
        ERROR_MESSAGE
      end

      cast
    end

    # @param privacy [String, Symbol]
    # @return [Symbol]
    #
    # @api private
    # @since 0.1.0
    def prepare_privacy_param(privacy)
      unless privacy.is_a?(String) || privacy.is_a?(Symbol)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute privacy should be a type of String or Symbol
        ERROR_MESSAGE
      end

      SmartCore::Initializer::Attribute::Parameters::PRIVACY_MODES.fetch(privacy.to_sym) do
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Incorrect attribute privacy identifier "#{privacy}"
        ERROR_MESSAGE
      end
    end

    # @param finalize [String, Symbol, Proc]
    # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
    #
    # @api private
    # @since 0.1.0
    def prepare_finalize_param(finalize)
      unless finalize.is_a?(String) || finalize.is_a?(Symbol) || finalize.is_a?(Proc)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute finalizer should be a type of String, Symbol or Proc
        ERROR_MESSAGE
      end

      SmartCore::Initializer::Attribute::Finalizer.create(finalize)
    end

    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [Hash<Symbol,Any>]
    #
    # @api private
    # @since 0.1.0
    def prepare_dynamic_options_param(dynamic_options)
      # :nocov:
      unless dynamic_options.is_a?(Hash)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute dynamic options should be a type of Hash
        ERROR_MESSAGE
      end
      # :nocov:

      dynamic_options
    end

    # @param name [String]
    # @param type [SmartCore::Types::Primitive]
    # @param privacy [Symbol]
    # @param finalize [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
    # @param cast [Boolean]
    # @param dynamic_options [Hash<Symbol,String>]
    # @return [SmartCore::Initializer::Attribute]
    #
    # @api private
    # @since 0.1.0
    def create_attribute(name, type, privacy, finalize, cast, dynamic_options)
      SmartCore::Initializer::Attribute.new(name, type, privacy, finalize, cast, dynamic_options)
    end
  end
end
