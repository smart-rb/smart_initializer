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
  # @version 0.12.1
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
  # @version 0.12.1
  def add(extension)
    @lock.write_sync do
      extensions << extension
      @snapshot = extensions.dup.freeze
    end
  end
  alias_method :<<, :add

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
  # @note Lock-free: iterates the immutable snapshot maintained on mutation.
  #
  # @api private
  # @since 0.1.0
  # @version 0.12.1
  def each(&block)
    block_given? ? @snapshot.each(&block) : @snapshot.each
  end

  # @return [Integer]
  #
  # @note Lock-free: reads the size of the immutable snapshot.
  #
  # @api private
  # @since 0.1.0
  # @version 0.12.1
  def size
    @snapshot.size
  end

  private

  # @return [Array<SmartCore::Initializer::Extensions::Abstract>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :extensions
end
