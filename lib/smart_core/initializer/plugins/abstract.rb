# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.10.0
class SmartCore::Initializer::Plugins::Abstract
  class << self
    # @param child_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    # @version 0.10.0
    def inherited(child_klass)
      child_klass.instance_variable_set(:@__loaded__, false)
      child_klass.instance_variable_set(:@__lock__, SmartCore::Engine::Lock.new)
      super
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load!
      __thread_safe__ do
        unless @__loaded__
          @__loaded__ = true
          install!
        end
      end
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def loaded?
      __thread_safe__ { @__loaded__ }
    end

    private

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def install!; end

    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def __thread_safe__(&block)
      @__lock__.synchronize(&block)
    end
  end
end
