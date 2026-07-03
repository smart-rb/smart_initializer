# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Finalizer
  # @pai private
  # @since 0.1.0
  class AnonymousBlock < Abstract
    # @param finalizer [Proc]
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
      instance.instance_exec(value, &finalizer)
    end

    # @return [Boolean] true only when wrapping the shared identity default,
    #   which returns its argument untouched (so a value validated before the
    #   call is still valid after it).
    #
    # @api private
    # @since 0.12.1
    def default_identity?
      finalizer.equal?(SmartCore::Initializer::Attribute::Value::Base::DEFAULT_FINALIZER)
    end

    private

    # @return [NilClass, Any]
    #
    # @api private
    # @since 0.1.0
    attr_reader :finalizer
  end
end
