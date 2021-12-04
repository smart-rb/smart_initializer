# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Factory
  # @api private
  # @since 0.8.0
  class Param < Base
    class << self
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
      # @since 0.8.0
      def create(name, type, type_system, privacy, finalize, cast, mutable, as)
        prepared_name        = prepare_name_param(name)
        prepared_privacy     = prepare_privacy_param(privacy)
        prepared_finalize    = prepare_finalize_param(finalize)
        prepared_cast        = prepare_cast_param(cast)
        prepared_type_system = prepare_type_system_param(type_system)
        prepared_type        = prepare_type_param(type, prepared_type_system)
        prepared_mutable     = prepare_mutable_param(mutable)
        prepared_as          = preapre_as_param(as)

        create_attribute(
          prepared_name,
          prepared_type,
          prepared_type_system,
          prepared_privacy,
          prepared_finalize,
          prepared_cast,
          prepared_mutable,
          prepared_as
        )
      end

      private

      # @param name [String]
      # @param type [SmartCore::Initializer::TypeSystem::Interop]
      # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
      # @param privacy [Symbol]
      # @param finalize [SmartCore::Initializer::Attribute::Finalizer::Abstract]
      # @param cast [Boolean]
      # @param mutable [Boolean]
      # @param as [String, Symbol]
      # @return [SmartCore::Initializer::Attribute::Value::Param]
      #
      # @api private
      # @since 0.8.0
      def create_attribute(name, type, type_system, privacy, finalize, cast, mutable, as)
        SmartCore::Initializer::Attribute::Value::Param.new(
          name, type, type_system, privacy, finalize, cast, mutable, as
        )
      end
    end
  end
end
