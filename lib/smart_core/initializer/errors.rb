# frozen_string_literal: true

module SmartCore::Initializer
  # @api public
  # @since 0.1.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.1.0
  OptionOverlapError = Class.new(ArgumentError)

  # @api public
  # @since 0.1.0
  ParameterOverlapError = Class.new(ArgumentError)
end
