# frozen_string_literal: true

class SmartCore::Initializer::TypeSystem::Interop
  # @api private
  # @since 0.1.0
  class SmartTypes::Cast < Operation
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
