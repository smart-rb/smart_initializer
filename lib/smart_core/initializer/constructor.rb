# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Constructor
  # @param klass [Class<SmartCore::Initializer>]
  # @param arguments [Array<Any>]
  # @param block [Proc, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(klass, arguments, block)
    @klass = klass
    @arguments = arguments
    @block = block
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def construct
    klass.allocate
  end

  private

  # @return [Class]
  #
  # @api private
  # @since 0.1.0
  attr_reader :klass

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :arguments

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :block
end
