# frozen_string_literal: true

module SmartCore::Initializer
  # @api public
  # @since 0.1.0
  ThyTypesError = Class.new(SmartCore::Initializer::Error)

  # @api public
  # @since 0.1.0
  ThyTypeValidationError = Class.new(ThyTypesError)
end
