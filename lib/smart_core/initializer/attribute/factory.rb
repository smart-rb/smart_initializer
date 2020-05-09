# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Factory
  class << self
    # @param name [String, Symbol]
    # @param type [String, Symbol, Any]
    # @param type_system [String, Symbol]
    # @param privacy [String, Symbol]
    # @param finalize [String, Symbol, Proc]
    # @param cast [Boolean]
    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [SmartCore::Initializer::Attribute]
    #
    # @api private
    # @since 0.1.0
    def create(name, type, type_system, privacy, finalize, cast, dynamic_options)
      prepared_name            = prepare_name_param(name)
      prepared_privacy         = prepare_privacy_param(privacy)
      prepared_finalize        = prepare_finalize_param(finalize)
      prepared_cast            = prepare_cast_param(cast)
      prepared_type_system     = prepare_type_system_param(type_system)
      prepared_type            = prepare_type_param(type, prepared_type_system)
      prepared_dynamic_options = prepare_dynamic_options_param(dynamic_options)

      create_attribute(
        prepared_name,
        prepared_type,
        prepared_type_system,
        prepared_privacy,
        prepared_finalize,
        prepared_cast,
        prepared_dynamic_options
      )
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

    # @param type [String, Symbol, Any]
    # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
    # @return [SmartCore::Initializer::TypeSystem::Interop]
    #
    # @api private
    # @since 0.1.0
    def prepare_type_param(type, type_system)
      type_primitive =
        if type.is_a?(String) || type.is_a?(Symbol)
          type_system.type_from_alias(type)
        else
          type
        end

      type_system.create(type_primitive)
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

    # @param type_system [String, Symbol]
    # @return [Class<SmartCore::Initializer::TypeSystem::Interop>]
    #
    # @api private
    # @since 0.1.0
    def prepare_type_system_param(type_system)
      SmartCore::Initializer::TypeSystem.resolve(type_system)
    end

    # @param name [String]
    # @param type [SmartCore::Initializer::TypeSystem::Interop]
    # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
    # @param privacy [Symbol]
    # @param finalize [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
    # @param cast [Boolean]
    # @param dynamic_options [Hash<Symbol,String>]
    # @return [SmartCore::Initializer::Attribute]
    #
    # @api private
    # @since 0.1.0
    def create_attribute(name, type, type_system, privacy, finalize, cast, dynamic_options)
      SmartCore::Initializer::Attribute.new(
        name, type, type_system, privacy, finalize, cast, dynamic_options
      )
    end
  end
end
