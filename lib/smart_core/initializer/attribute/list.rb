# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.10.0
class SmartCore::Initializer::Attribute::List
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def initialize
    @attributes = {}
    # NOTE: frozen snapshot of attribute values, rebuilt on each mutation so the
    #   read-heavy instantiation path (see Constructor) can iterate lock-free.
    @snapshot = [].freeze
    @names = [].freeze
    @required_option_names = nil
    @lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @param attribute_name [Symbol]
  # @return [SmartCore::Initializer::Atribute]
  #
  # @raise [SmartCore::Initializer::UndefinedAttributeError]
  #
  # @api private
  # @since 0.8.0
  # @version 0.10.0
  def fetch(attribute_name)
    @lock.read_sync do
      raise(
        ::SmartCore::Initializer::UndefinedAttributeError,
        "Attribute with `#{attribute_name}` name is not defined in your constructor. " \
        "Please, check your attribute definitions inside your class."
      ) unless attributes.key?(attribute_name)

      attributes[attribute_name]
    end
  end
  alias_method :[], :fetch

  # @param attribute [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def add(attribute)
    @lock.write_sync do
      attributes[attribute.name] = attribute
      @snapshot = attributes.values.freeze
      @names = @snapshot.map(&:name).freeze
      @required_option_names = nil
    end
  end
  alias_method :<<, :add

  # @return [Array<SmartCore::Initializer::Attribute>]
  #
  # @note Lock-free: returns the frozen snapshot maintained on mutation.
  #   Intended for the read-only instantiation path where the definition
  #   list is already fully built.
  #
  # @api private
  # @since 0.12.0
  def to_a
    @snapshot
  end

  # @return [Array<Symbol>] names of all attributes in the list
  #
  # @note Lock-free, memoized on mutation. Used on the instantiation path.
  #
  # @api private
  # @since 0.12.0
  def names
    @names
  end

  # @return [Array<Symbol>] names of options that must be provided explicitly
  #
  # @note Lock-free, memoized (invalidated on mutation). Only meaningful for
  #   an options list — its members respond to #has_default?/#optional?.
  #
  # @api private
  # @since 0.12.0
  def required_option_names
    @required_option_names ||=
      @snapshot.reject(&:has_default?).reject(&:optional?).map(&:name).freeze
  end

  # @param list [SmartCore::Initializer::Attribute::List]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def concat(list)
    @lock.write_sync do
      list.each { |attribute| add(attribute.dup) }
    end
  end

  # @param attribute [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def include?(attribute)
    @lock.read_sync { attributes.key?(attribute.name) }
  end

  # @param block [Block]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def each(&block)
    @lock.read_sync do
      block_given? ? attributes.values.each(&block) : attributes.values.each
    end
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def size
    @lock.read_sync { attributes.size }
  end

  # @param block [Block]
  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  # @version 0.10.0
  def count(&block)
    @lock.read_sync { attributes.values.count(&block) }
  end

  private

  # @return [Hash<String,SmartCore::Initializer::Attribute>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :attributes
end
