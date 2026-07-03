# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.10.0
class SmartCore::Initializer::Extensions::List
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def initialize
    @extensions = []
    # NOTE: frozen snapshot rebuilt on mutation so the instantiation path can
    #   iterate (and skip when empty) lock-free.
    @snapshot = [].freeze
    @lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @param extension [SmartCore::Initializer::Extensions::Abstract]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def add(extension)
    @lock.write_sync do
      extensions << extension
      @snapshot = extensions.dup.freeze
    end
  end
  alias_method :<<, :add

  # @return [Array<SmartCore::Initializer::Extensions::Abstract>]
  #
  # @note Lock-free: returns the frozen snapshot maintained on mutation.
  #
  # @api private
  # @since 0.12.0
  def to_a
    @snapshot
  end

  # @param list [SmartCore::Initializer::Extensions::List]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
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
  # @version 0.10.0
  def each(&block)
    @lock.read_sync do
      block_given? ? extensions.each(&block) : extensions.each
    end
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
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
