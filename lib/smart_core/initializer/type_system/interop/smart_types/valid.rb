# frozen_string_literal: true

class SmartCore::Initializer::TypeSystem::Interop
  # @api private
  # @since 0.1.0
  class SmartTypes::Valid < Operation
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
