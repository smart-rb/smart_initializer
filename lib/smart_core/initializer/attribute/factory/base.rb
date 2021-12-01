# frozen_string_literal: true

# @api private
# @since 0.8.0
class SmartCore::Initializer::Attribute::Factory::Base
  class << self
    # @!method create(*params)
    #   @param params [Any] List of appropriated attributes for the corresponding factory
    #   @return [SmartCore::Initializer::Attribute::Base]

    private

    # @param name [String, Symbol]
    # @return [Symbol]
    #
    # @api private
    # @since 0.8.0
    def prepare_name_param(name)
      unless name.is_a?(::String) || name.is_a?(::Symbol)
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
    # @since 0.8.0
    def prepare_type_param(type, type_system)
      type_primitive =
        if type.is_a?(::String) || type.is_a?(::Symbol)
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
    # @since 0.8.0
    def prepare_cast_param(cast)
      unless cast.is_a?(::TrueClass) || cast.is_a?(::FalseClass)
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
    # @since 0.8.0
    def prepare_privacy_param(privacy)
      unless privacy.is_a?(::String) || privacy.is_a?(::Symbol)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute privacy should be a type of String or Symbol
        ERROR_MESSAGE
      end

      SmartCore::Initializer::Attribute::Value::Base::PRIVACY_MODES.fetch(privacy.to_sym) do
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Incorrect attribute privacy identifier "#{privacy}"
        ERROR_MESSAGE
      end
    end

    # @param finalize [String, Symbol, Proc]
    # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
    #
    # @api private
    # @since 0.8.0
    def prepare_finalize_param(finalize)
      unless finalize.is_a?(::String) || finalize.is_a?(::Symbol) || finalize.is_a?(::Proc)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute finalizer should be a type of String, Symbol or Proc
        ERROR_MESSAGE
      end

      SmartCore::Initializer::Attribute::Finalizer.create(finalize)
    end

    # @param mutable [Boolean]
    # @return [Boolean]
    #
    # @api private
    # @since 0.4.0
    def prepare_mutable_param(mutable)
      unless mutable.is_a?(::FalseClass) || mutable.is_a?(::TrueClass)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          :mutable attribute should be a type of boolean
        ERROR_MESSAGE
      end

      mutable
    end

    # @param [String, Symbol, NilClass]
    # @return [String, Symbol, NilClass]
    #
    # @api private
    # @since 0.4.0
    def preapre_as_param(as)
      unless as.is_a?(::NilClass) || as.is_a?(::String) || as.is_a?(::Symbol)
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Attribute alias should be a type of String or Symbol
        ERROR_MESSAGE
      end

      as
    end

    # @param type_system [String, Symbol]
    # @return [Class<SmartCore::Initializer::TypeSystem::Interop>]
    #
    # @api private
    # @since 0.8.0
    def prepare_type_system_param(type_system)
      SmartCore::Initializer::TypeSystem.resolve(type_system)
    end
  end
end
