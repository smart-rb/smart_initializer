# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::DryTypes::Operation
  # @api private
  # @since 0.4.1
  class Valid < Base
    # @param value [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.4.1
    def call(value)
      type.valid?(value)
    end
  end
end
