# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Extensions::List
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @extensions = []
    @lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @param extension [SmartCore::Initializer::Extensions::Abstract]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add(extension)
    @lock.write_sync { extensions << extension }
  end
  alias_method :<<, :add

  # @param list [SmartCore::Initializer::Extensions::List]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def concat(list)
    @lock.write_sync do
      list.each { |extension| add(extension.dup) }
    end
  end

  # @param block [Block]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    @lock.read_sync do
      block_given? ? extensions.each(&block) : extensions.each
    end
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  def size
    @lock.read_sync { extensions.size }
  end

  private

  # @return [Array<SmartCore::Initializer::Extensions::Abstract>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :extensions
end
