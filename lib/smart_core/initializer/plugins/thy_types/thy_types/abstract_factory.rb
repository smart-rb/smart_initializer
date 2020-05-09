# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api private
  # @since 0.1.0
  class ThyTypes::AbstractFactory < Interop::AbstractFactory
    class << self
      # @param type [Thy::Type]
      # @return [void]
      #
      # @raise [SmartCore::Initializer::IncorrectTypeObjectError]
      #
      # @api private
      # @since 0.1.0
      def prevent_incompatible_type!(type)
        unless type.is_a?(::Thy::Type)
          raise(
            SmartCore::Initializer::IncorrectTypeObjectError,
            'Incorrect Thy::Type primitive ' \
            '(type object should be a type of Thy::Type)'
          )
        end
      end

      # @param type [Thy::Type]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Valid]
      #
      # @api private
      # @since 0.1.0
      def build_valid_operation(type)
        ThyTypes::Operation::Valid.new(type)
      end

      # @return [SmartCore::Types::Value::Any]
      #
      # @api private
      # @since 0.1.0
      def generic_type_object
        SmartCore::Types::Value::Any
      end

      # @param type [Thy::Type]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Validate]
      #
      # @api private
      # @since 0.1.0
      def build_validate_operation(type)
        ThyTypes::Operation::Validate.new(type)
      end

      # @param type [Thy::Type]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Cast]
      #
      # @api private
      # @since 0.1.0
      def build_cast_operation(type)
        ThyTypes::Operation::Cast.new(type)
      end

      # @param valid_op [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Valid]
      # @param valid_op [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Validate]
      # @param valid_op [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Cast]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes]
      #
      # @api private
      # @since 0.1.0
      def build_interop(valid_op, validate_op, cast_op)
        ThyTypes.new(valid_op, validate_op, cast_op)
      end
    end
  end
end
