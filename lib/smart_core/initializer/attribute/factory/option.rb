# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Factory
  # @api private
  # @since 0.8.0
  class Option < Base
    class << self
      # @param klass [Class]
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
      # @since 0.8.0
      def create(klass, name, type, type_system, privacy, finalize, cast, mutable, as, default, optional)
        prepared_name        = prepare_name_param(name)
        prepared_privacy     = prepare_privacy_param(privacy)
        prepared_finalize    = prepare_finalize_param(finalize)
        prepared_cast        = prepare_cast_param(cast)
        prepared_type_system = prepare_type_system_param(type_system)
        prepared_type        = prepare_type_param(type, prepared_type_system)
        prepared_mutable     = prepare_mutable_param(mutable)
        prepared_as          = prepare_as_param(as)
        prepared_default     = prepare_default_param(default)
        prepared_optional    = prepare_optional_param(optional)

        create_attribute(
          klass,
          prepared_name,
          prepared_type,
          prepared_type_system,
          prepared_privacy,
          prepared_finalize,
          prepared_cast,
          prepared_mutable,
          prepared_as,
          prepared_default,
          prepared_optional
        )
      end

      private

      # @param klass [Class]
      # @param name [String]
      # @param type [SmartCore::Initializer::TypeSystem::Interop]
      # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
      # @param privacy [Symbol]
      # @param finalize [SmartCore::Initializer::Attribute::Finalizer::Abstract]
      # @param cast [Boolean]
      # @param mutable [Boolean]
      # @param as [String, Symbol]
      # @param default [Proc, Any]
      # @param optional [Boolean]
      # @return [SmartCore::Initializer::Attribute::Value::Option]
      #
      # @api private
      # @since 0.8.0
      def create_attribute(
        klass,
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
        SmartCore::Initializer::Attribute::Value::Option.new(
          klass, name, type, type_system, privacy, finalize, cast, mutable, as, default, optional
        )
      end

      # @param default [Proc, Any]
      # @return [Proc, Any]
      #
      # @api private
      # @since 0.8.0
      def prepare_default_param(default)
        # NOTE: this "strange" approach is used to comply the default Factory methods approach here
        default
      end

      # @param optional [Boolean]
      # @return [Boolean]
      #
      # @api private
      # @since 0.8.0
      def prepare_optional_param(optional)
        unless optional.is_a?(::TrueClass) || optional.is_a?(::FalseClass)
          raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
            :optional attribute should be a type of boolean
          ERROR_MESSAGE
        end

        optional
      end
    end
  end
end
