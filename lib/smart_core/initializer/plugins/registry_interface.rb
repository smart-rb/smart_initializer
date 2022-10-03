# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Plugins::RegistryInterface
  class << self
    # @param base_module [Class, Module]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def extended(base_module)
      base_module.instance_variable_set(
        :@plugin_registry, SmartCore::Initializer::Plugins::Registry.new
      )
      base_module.instance_variable_set(
        :@access_lock, SmartCore::Engine::ReadWriteLock.new
      )
    end
  end

  # @param plugin_name [Symbol, String]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def load(plugin_name)
    @access_lock.read_sync { plugin_registry[plugin_name].load! }
  end

  # @return [Array<String>]
  #
  # @api public
  # @since 0.1.0
  def loaded_plugins
    @access_lock.read_sync { plugin_registry.loaded.keys }
  end

  # @return [Array<String>]
  #
  # @api public
  # @since 0.1.0
  def names
    @access_lock.read_sync { plugin_registry.names }
  end

  # @param plugin_name [Symbol, String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register_plugin(plugin_name, plugin_module)
    @access_lock.write_sync { plugin_registry[plugin_name] = plugin_module }
  end

  private

  # @return [SmartCore::Initializer::Plugins::Registry]
  #
  # @api private
  # @since 0.1.0
  attr_reader :plugin_registry
end
