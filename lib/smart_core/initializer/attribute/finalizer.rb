# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Attribute::Finalizer
  require_relative 'finalizer/abstract'
  require_relative 'finalizer/instance_method'
  require_relative 'finalizer/anonymous_block'

  class << self
    # @param finalization_approach [String, Symbol, Proc]
    # @return [SmartCore::Initializer::Attribute::Finalizer::InstanceMethod]
    # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock]
    #
    # @api private
    # @since 0.1.0
    def create(finalization_approach)
      case finalization_approach
      when String, Symbol
        InstanceMethod.new(finalization_approach)
      when Proc
        AnonymousBlock.new(finalization_approach)
      else
        # :nocov:
        raise(SmartCore::Initializer::ArgumentError, <<~ERROR_MESSAGE)
          Finalization approach should be a type of Proc, Symbol or String'
        ERROR_MESSAGE
        # :nocov:
      end
    end
  end
end
