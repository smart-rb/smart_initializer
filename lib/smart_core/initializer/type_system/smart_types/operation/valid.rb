# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::SmartTypes::Operation
  # @api private
  # @since 0.1.0
  class Valid < Base
    # @param value [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def call(value)
      type.valid?(value)
    end
  end
end
