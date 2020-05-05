# frozen_string_literal: true

class SmartCore::Initializer::TypeSystem::Interop
  # @api private
  # @since 0.1.0
  class SmartTypes::Validate < Operation
    # @param value [Any]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(value)
      type.validate!(value)
    end
  end
end
