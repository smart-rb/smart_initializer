# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem::SmartTypes::Operation
  # @api private
  # @since 0.1.0
  class Cast < Base
    # @param value [Any]
    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def call(value)
      type.cast(value)
    end
  end
end
