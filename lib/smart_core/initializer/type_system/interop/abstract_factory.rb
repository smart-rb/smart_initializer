# frozen_string_literal: true

# @abstract
# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::Interop::AbstractFactory
  class << self
    # @param type [Any]
    # @return [SmartCore::Initializer::TypeSystem::Interop]
    #
    # @api private
    # @since 0.1.0
    def create(type)
      prevent_incompatible_type!(type)

      valid_op = build_valid_operation(type)
      validate_op = build_validate_operation(type)
      cast_op = build_cast_operation(type)

      force_cast = force_cast_for?(type)

      build_interop(valid_op, validate_op, cast_op, force_cast)
    end

    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def generic_type_object; end

    # @param type [Any]
    # @return [void]
    #
    # @raise [SmartCore::Initializer::IncorrectTypeObjectError]
    #
    # @api private
    # @since 0.1.0
    def prevent_incompatible_type!(type); end

    private

    # @param type [Any]
    # @return [SmartCore::Initializer::TypeSystem::Interop::Operation]
    #
    # @api private
    # @since 0.1.0
    def build_valid_operation(type); end

    # @param type [Any]
    # @return [SmartCore::Initializer::TypeSystem::Interop::Operation]
    #
    # @api private
    # @since 0.1.0
    def build_validate_operation(type); end

    # @param type [Any]
    # @return [SmartCore::Initializer::TypeSystem::Interop::Operation]
    #
    # @api private
    # @since 0.1.0
    def build_cast_operation(type); end

    # @param type [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.4.1
    def force_cast_for?(type)
      false
    end

    # @param valid_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
    # @param validate_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
    # @param cast_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
    # @param force_cast [Boolean]
    # @return [SmartCore::Initializer::TypeSystem::Interop]
    #
    # @api private
    # @since 0.1.0
    def build_interop(valid_op, validate_op, cast_op, force_cast); end
  end
end
