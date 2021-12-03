# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Finalizer
  # @pai private
  # @since 0.1.0
  class InstanceMethod < Abstract
    # @param finalizer [String, Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(finalizer)
      @finalizer = finalizer
    end

    # @param value [Any]
    # @param instance [Any]
    # @return [value]
    #
    # @pai private
    # @since 0.1.0
    def call(value, instance)
      instance.__send__(finalizer, value)
    end

    private

    # @return [NilClass, Any]
    #
    # @api private
    # @since 0.1.0
    attr_reader :finalizer
  end
end
