# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Extensions::ExtInit < SmartCore::Initializer::Extensions::Abstract
  # @param extender [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(extender)
    @extender = extender
  end

  # @param instance [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call(instance)
    extender.call(instance)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since0 0.1.0
  attr_reader :extender
end
