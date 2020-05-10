# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::ThyTypes::Operation
  # @api private
  # @since 0.1.0
  class Valid < Base
    # @param value [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def call(value)
      type.check(value).success?
    end
  end
end
