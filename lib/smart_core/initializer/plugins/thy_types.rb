# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Plugins::ThyTypes < SmartCore::Initializer::Plugins::Abstract
  class << self
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def install!
      raise(
        SmartCore::Initializer::UnresolvedPluginDependencyError,
        '::Thy does not exist or "thy" gem is not loaded'
      ) unless const_defined?('::Thy')

      # NOTE: require necessary dependencies
      require 'date'

      # NOTE: add thy-types type system implementation
      require_relative 'thy_types/errors'
      require_relative 'thy_types/thy_types'

      # NOTE: register thy-types type system
      SmartCore::Initializer::TypeSystem.register(
        :thy_types, SmartCore::Initializer::TypeSystem::ThyTypes
      )
    end
  end
end
