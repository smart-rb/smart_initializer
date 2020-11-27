# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Plugins
  require_relative 'plugins/abstract'
  require_relative 'plugins/registry'
  require_relative 'plugins/registry_interface.rb'
  require_relative 'plugins/access_mixin'
  require_relative 'plugins/thy_types'
  require_relative 'plugins/dry_types'

  # @since 0.1.0
  extend SmartCore::Initializer::Plugins::RegistryInterface

  # @since 0.1.0
  register_plugin('thy_types', SmartCore::Initializer::Plugins::ThyTypes)
  register_plugin('dry_types', SmartCore::Initializer::Plugins::DryTypes)
end
