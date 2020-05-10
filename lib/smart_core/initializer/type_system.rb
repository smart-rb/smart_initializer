# frozen_string_literal: true

# @api public
# @since 0.1.0
module SmartCore::Initializer::TypeSystem
  require_relative 'type_system/interop'
  require_relative 'type_system/registry'
  require_relative 'type_system/smart_types'
  require_relative 'type_system/registry_interface'

  # @since 0.1.0
  extend SmartCore::Initializer::TypeSystem::RegistryInterface

  # @since 0.1.0
  register(:smart_types, SmartCore::Initializer::TypeSystem::SmartTypes)
end
