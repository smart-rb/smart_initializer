# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Plugins::Registry
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @plugin_set = {}
    @access_lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @param plugin_name [Symbol, String]
  # @return [SmartCore::Initializer::Plugins::Abstract]
  #
  # @api private
  # @since 0.1.0
  def [](plugin_name)
    @access_lock.read_sync { fetch(plugin_name) }
  end

  # @param plugin_name [Symbol, String]
  # @param plugin_module [SmartCore::Initializer::Plugins::Abstract]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(plugin_name, plugin_module)
    @access_lock.write_sync { apply(plugin_name, plugin_module) }
  end
  alias_method :[]=, :register

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def names
    @access_lock.read_sync { plugin_names }
  end

  # @return [Hash<String,Class<SmartCore::Initializer::Plugins::Abstract>>]
  #
  # @api private
  # @since 0.1.0
  def loaded
    @access_lock.read_sync { loaded_plugins }
  end

  # @param block [Block]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    @access_lock.read_sync { iterate(&block) }
  end

  private

  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  attr_reader :plugin_set

  # @return [Mutex]
  #
  # @api private
  # @since 0.1.0
  attr_reader :access_lock

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def plugin_names
    plugin_set.keys
  end

  # @param block [Block]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def iterate(&block)
    block_given? ? plugin_set.each_pair(&block) : plugin_set.each_pair
  end

  # @param plugin_name [String]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def registered?(plugin_name)
    plugin_set.key?(plugin_name)
  end

  # @return [Array<SmartCore::Initializer::Plugins::Abstract>]
  #
  # @api private
  # @since 0.1.0
  def loaded_plugins
    plugin_set.select { |_plugin_name, plugin_module| plugin_module.loaded? }
  end

  # @param plugin_name [Symbol, String]
  # @param plugin_module [SmartCore::Initializer::Plugins::Abstract]
  # @return [void]
  #
  # @raise [SmartCore::Initializer::AlreadyRegisteredPluginError]
  #
  # @api private
  # @since 0.1.0
  def apply(plugin_name, plugin_module)
    plugin_name = indifferently_accessible_plugin_name(plugin_name)

    if registered?(plugin_name)
      raise(SmartCore::Initializer::AlreadyRegisteredPluginError, <<~ERROR_MESSAGE)
        #{plugin_name} plugin already exists
      ERROR_MESSAGE
    end

    plugin_set[plugin_name] = plugin_module
  end

  # @param plugin_name [Symbol, String]
  # @return [SmartCore::Initializer::Plugins::Abstract]
  #
  # @raise [SmartCore::Initializer::UnregisteredPluginError]
  #
  # @api private
  # @since 0.1.0
  def fetch(plugin_name)
    plugin_name = indifferently_accessible_plugin_name(plugin_name)

    unless registered?(plugin_name)
      raise(SmartCore::Initializer::UnregisteredPluginError, <<~ERROR_MESSAGE)
        #{plugin_name} plugin is not registered
      ERROR_MESSAGE
    end

    plugin_set[plugin_name]
  end

  # @param key [Symbol, String]
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def indifferently_accessible_plugin_name(plugin_name)
    plugin_name.to_s
  end
end
