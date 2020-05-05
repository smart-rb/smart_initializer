# frozen_string_literal: true

# @abstract
# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::Interop::Aliasing::AliasList
  # @param interop_klass [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(interop_klass)
    @interop_klass = interop_klass
    @list = {}
    @lock = SmartCore::Engine::Lock.new
  end

  # @param alias_name [String, Symbol]
  # @param type [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def associate(alias_name, type)
    interop_klass.prevent_incompatible_type!(type)
    thread_safe { set_alias(alias_name, type) }
  end

  # @param alias_name [String, Symbol]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def resolve(alias_name)
    thread_safe { get_alias(alias_name) }
  end

  private

  # @return [Hash<String,Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :list

  # @return [Class<SmartCore::Initializer::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :interop_klass

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end

  # @param alias_name [String, Symbol]
  # @param type [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def set_alias(alias_name, type)
    alias_name = normalized_alias(alias_name)

    if list.key?(alias_name)
      ::Warning.warn("Shadowing of already existing \"#{alias_name}\" type alias.")
    end

    list[alias_name] = type
  end

  # @param alias_name [String, Symbol]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def get_alias(alias_name)
    alias_name = normalized_alias(alias_name)

    begin
      list.fetch(alias_name)
    rescue ::KeyError
      raise(SmartCore::Initializer::TypeAliasNotFoundError, <<~ERROR_MESSAGE)
        Alias with name "#{alias_name}" not found.
      ERROR_MESSAGE
    end
  end

  # @param alias_name [String, Symbol]
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def normalized_alias(alias_name)
    raise(
      SmartCore::Initializer::ArgumentError,
      'Type alias should be a type of string or symbol'
    ) unless alias_name.is_a?(String) || alias_name.is_a?(Symbol)

    alias_name.to_s
  end
end
