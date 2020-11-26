# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::DryTypes::Operation
  # @api private
  # @since 0.3.4
  class Validate < Base
    # @param value [Any]
    # @return [void]
    #
    # @api private
    # @since 0.3.4
    def call(value)
      raise(
        SmartCore::Initializer::DryTypeValidationError,
        "Dry validation error: (get #{value.inspect} for type #{type.inspect}"
      ) unless type.valid?(value)
    end
  end
end
