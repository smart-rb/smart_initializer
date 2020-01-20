# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Attribute::Finalizer
  require_relative 'finalizer/non_mutating'
  require_relative 'finalizer/instance_method'
  require_relative 'finalizer/anonymous_block'

  # @return [Class{SmartCore::Initializer::Attribute::Finalizer::NonMutating}]
  #
  # @api private
  # @since 0.1.0
  DEFAULT = SmartCore::Initializer::Attribute::Finalizer::NonMutating

  class << self
    # @return [SmartCore::Initializer::Attribute::Finalizer::NonMutating]
    # @return [SmartCore::Initializer::Attribute::Finalizer::InstanceMethod]
    # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock]
    #
    # @api private
    # @since 0.1.0
    def create
    end
  end
end
