# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api private
  # @since 0.1.0
  class ThyTypes::AbstractFactory < Interop::AbstractFactory
    # @return [Thy::Type]
    #
    # @api private
    # @since 0.1.0
    GENERIC_TYPE = ::Thy::Type.new { true }

    class << self
      # @param type [Thy::Type, #check]
      # @return [void]
      #
      # @raise [SmartCore::Initializer::IncorrectTypeObjectError]
      #
      # @api private
      # @since 0.1.0
      def prevent_incompatible_type!(type)
        unless type.respond_to?(:check) || type.is_a?(::Thy::Type)
          raise(
            SmartCore::Initializer::IncorrectTypeObjectError,
            'Incorrect Thy::Type primitive ' \
            '(type object should respond to :check method)'
          )
        end
      end

      # @param type [Any]
      # @return [String]
      #
      # @api private
      # @since 0.5.1
      def build_identifier(type)
        type.name
      end

      # @param type [Thy::Type, #check]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Valid]
      #
      # @api private
      # @since 0.1.0
      def build_valid_operation(type)
        ThyTypes::Operation::Valid.new(type)
      end

      # @return [Thy::Type, #check]
      #
      # @api private
      # @since 0.1.0
      def generic_type_object
        GENERIC_TYPE
      end

      # @param type [Thy::Type, #check]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Validate]
      #
      # @api private
      # @since 0.1.0
      def build_validate_operation(type)
        ThyTypes::Operation::Validate.new(type)
      end

      # @param type [Thy::Type, #check]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Cast]
      #
      # @api private
      # @since 0.1.0
      def build_cast_operation(type)
        ThyTypes::Operation::Cast.new(type)
      end

      # @param identifier [String]
      # @param valid_op [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Valid]
      # @param valid_op [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Validate]
      # @param valid_op [SmartCore::Initializer::TypeSystem::ThyTypes::Operation::Cast]
      # @return [SmartCore::Initializer::TypeSystem::ThyTypes]
      #
      # @api private
      # @since 0.1.0
      # @version 0.5.1
      def build_interop(identifier, valid_op, validate_op, cast_op)
        ThyTypes.new(identifier, valid_op, validate_op, cast_op)
      end
    end
  end
end
