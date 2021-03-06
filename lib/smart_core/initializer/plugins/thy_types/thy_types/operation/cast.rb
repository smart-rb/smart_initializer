# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::ThyTypes::Operation
  # @api private
  # @since 0.1.0
  class Cast < Base
    # @param value [Any]
    # @return [void]
    #
    # @raise [SmartCore::Initializer::TypeCastingUnsupportedError]
    #
    # @api private
    # @since 0.1.0
    def call(value)
      raise(
        SmartCore::Initializer::TypeCastingUnsupportedError,
        'ThyTypes type system has no support for type casting.'
      )
    end
  end
end
