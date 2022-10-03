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
    @lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @param attribute_name [Symbol]
  # @return [SmartCore::Initializer::Atribute]
  #
  # @raise [SmartCore::Initializer::UndefinedAttributeError]
  #
  # @api private
  # @since 0.8.0
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
  def add(attribute)
    @lock.write_sync { attributes[attribute.name] = attribute }
  end
  alias_method :<<, :add

  # @param list [SmartCore::Initializer::Attribute::List]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
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
  def each(&block)
    @lock.read_sync do
      block_given? ? attributes.values.each(&block) : attributes.values.each
    end
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  def size
    @lock.read_sync { attributes.size }
  end

  # @param block [Block]
  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
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
