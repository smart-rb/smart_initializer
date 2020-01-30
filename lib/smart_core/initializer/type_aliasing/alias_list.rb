# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeAliasing::AliasList
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @list = {}
    @lock = SmartCore::Engine::Lock.new
  end

  # @param alias_name [String, Symbol]
  # @param type [SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def associate(alias_name, type)
    raise(
      SmartCore::Initializer::ArgumentError,
      'Type alias should be a type of string or symbol'
    ) unless alias_name.is_a?(String) || alias_name.is_a?(Symbol)

    raise(
      SmartCore::Initializer::ArgumentError,
      'Type object should be a type of SmartCore::Types::Primitive'
    ) unless type.is_a?(SmartCore::Types::Primitive)

    thread_safe { set_alias(alias_name, type) }
  end

  # @param alias_name [String, Symbol]
  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.1.0
  def resolve(alias_name)
    raise(
      SmartCore::Initializer::ArgumentError,
      'Type alias should be a type of string or symbol'
    ) unless alias_name.is_a?(String) || alias_name.is_a?(Symbol)

    thread_safe { get_alias(alias_name) }
  end

  private

  # @return [Hash<String,SmartCore::Types::Primitive>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :list

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end

  # @param alias_name [String, Symbol]
  # @param type [SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def set_alias(alias_name, type)
    alias_name = normalized_alias(alias_name)
    ::Warning.warn( # TODO: SmartCore::Engine::Instrumenting
      "[SmartCore::Initializer] Shadowing of already existing \"#{alias_name}\" type alias."
    ) if list.key?(alias_name)
    list[normalized_alias(alias_name)] = type
  end

  # @param alias_name [String, Symbol]
  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.1.0
  def get_alias(alias_name)
    list.fetch(normalized_alias(alias_name)) do
      raise(SmartCore::Initializer::NoTypeAliasError, <<~ERROR_MESSAGE)
        Alias with name "#{alias_name}" does not exist
      ERROR_MESSAGE
    end
  end

  # @param alias_name [String, Symbol]
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def normalized_alias(alias_name)
    alias_name.to_s
  end
end
