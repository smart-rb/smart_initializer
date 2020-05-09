# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::ThyTypes::Operation
  # @api private
  # @since 0.1.0
  class Validate < Base
    # @param value [Any]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(value)
      raise(
        SmartCore::Initializer::ThyTypesValidationError,
        "Thy::Types validation error: (get #{value.inspect} for type #{type.inspect}"
      ) unless type.check(value).success?
    end
  end
end
