# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::DryTypes::Operation
  # @api private
  # @since 0.3.4
  class Cast < Base
    # @param value [Any]
    # @return [Any]
    #
    # @api private
    # @since 0.3.4
    def call(value)
      type[value]
    rescue Dry::Types::CoercionError
      value
    end
  end
end
