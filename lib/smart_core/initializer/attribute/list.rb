# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::List
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @attributes = {}
    @lock = SmartCore::Engine::Lock.new
  end

  # @param attribute [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add(attribute)
    thread_safe { attributes[attribute.name] = attribute }
  end
  alias_method :<<, :add

  private

  # @return [Hash<String,SmartCore::Initializer::Attribute>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :attributes

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
