# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::List
  # @since 0.1.0
  include Enumerable

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

  # @param list [SmartCore::Initializer::Attribute::List]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def concat(list)
    thread_safe do
      list.each { |attribute| add(attribute.dup) }
    end
  end

  # @param attribute [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def include?(attribute)
    thread_safe { attributes.key?(attribute.name) }
  end

  # @param block [Block]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe do
      block_given? ? attributes.values.each(&block) : attributes.values.each
    end
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  def size
    thread_safe { attributes.size }
  end

  # @param block [Block]
  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  def count(&block)
    thread_safe { attributes.values.count(&block) }
  end

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
