# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Plugins::AccessMixin
  # @param plugin_name [Symbol, String]
  # @return [void]
  #
  # @see SmartCore::Initializer::Plugins
  #
  # @api public
  # @since 0.1.0
  def plugin(plugin_name)
    SmartCore::Initializer::Plugins.load(plugin_name)
  end
  alias_method :enable, :plugin
  alias_method :load, :plugin

  # @return [Array<String>]
  #
  # @see SmartCore::Initializer::Plugins
  #
  # @api public
  # @since 0.1.0
  def plugins
    SmartCore::Initializer::Plugins.names
  end

  # @return [Hash<String,Class<SmartCore::Initializer::Plugins::Abstract>>]
  #
  # @api private
  # @since 0.1.0
  def loaded_plugins
    SmartCore::Initializer::Plugins.loaded_plugins
  end
  alias_method :enabled_plugins, :loaded_plugins

  # @param plugin_name [String, Symbol]
  # @param plugin_klass [Class<SmartCore::Initializer::Plugins::Abstract>]
  # @return [void]
  #
  # @see SmartCore::Initializer::Plugins
  #
  # @api public
  # @since 0.1.0
  def register_plugin(plugin_name, plugin_klass)
    SmartCore::Initializer::Plugins.register_plugin(plugin_name, plugin_klass)
  end
end
