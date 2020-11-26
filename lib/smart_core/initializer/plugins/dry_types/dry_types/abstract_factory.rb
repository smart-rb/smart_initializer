# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api private
  # @since 0.3.4
  class DryTypes::AbstractFactory < Interop::AbstractFactory
    # @return [Dry::Types::AnyClass]
    #
    # @api private
    # @since 0.3.4
    GENERIC_TYPE = ::Dry::Types["any"]

    class << self
      # @param type [#valid?, #call]
      # @return [void]
      #
      # @raise [SmartCore::Initializer::IncorrectTypeObjectError]
      #
      # @api private
      # @since 0.3.4
      def prevent_incompatible_type!(type)
        unless type.respond_to?(:valid?) || type.respond_to?(:call)
          raise(
            SmartCore::Initializer::IncorrectTypeObjectError,
            'Incorrect Dry::Type primitive ' \
            '(type object should respond to :valid? and :call methods)'
          )
        end
      end

      # @param type [#valid?, #call]
      # @return [SmartCore::Initializer::TypeSystem::DryTypes::Operation::Valid]
      #
      # @api private
      # @since 0.3.4
      def build_valid_operation(type)
        DryTypes::Operation::Valid.new(type)
      end

      # @return [#valid?, #call]
      #
      # @api private
      # @since 0.3.4
      def generic_type_object
        GENERIC_TYPE
      end

      # @param type [#valid?, #call]
      # @return [SmartCore::Initializer::TypeSystem::DryTypes::Operation::Validate]
      #
      # @api private
      # @since 0.3.4
      def build_validate_operation(type)
        DryTypes::Operation::Validate.new(type)
      end

      # @param type [#valid?, #call]
      # @return [SmartCore::Initializer::TypeSystem::DryTypes::Operation::Cast]
      #
      # @api private
      # @since 0.3.4
      def build_cast_operation(type)
        DryTypes::Operation::Cast.new(type)
      end

      # @param type [Any]
      # @return [Boolean]
      #
      # @api private
      # @since 0.3.4
      def force_cast_for?(type)
        type.is_a?(Dry::Types::Constructor)
      end

      # @param valid_op [SmartCore::Initializer::TypeSystem::DryTypes::Operation::Valid]
      # @param valid_op [SmartCore::Initializer::TypeSystem::DryTypes::Operation::Validate]
      # @param valid_op [SmartCore::Initializer::TypeSystem::DryTypes::Operation::Cast]
      # @param force_cast [Boolean]
      # @return [SmartCore::Initializer::TypeSystem::DryTypes]
      #
      # @api private
      # @since 0.3.4
      def build_interop(valid_op, validate_op, cast_op, force_cast)
        DryTypes.new(valid_op, validate_op, cast_op, force_cast)
      end
    end
  end
end
