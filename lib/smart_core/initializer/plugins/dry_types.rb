# frozen_string_literal: true

# @api private
# @since 0.4.1
class SmartCore::Initializer::Plugins::DryTypes < SmartCore::Initializer::Plugins::Abstract
  class << self
    # @return [void]
    #
    # @api private
    # @since 0.4.1
    def install!
      raise(
        SmartCore::Initializer::UnresolvedPluginDependencyError,
        '::Dry::Types does not exist or "dry-types" gem is not loaded'
      ) unless const_defined?('::Dry::Types')

      # NOTE: require necessary dependencies
      require 'date'

      # NOTE: add dry-types type system implementation
      require_relative 'dry_types/errors'
      require_relative 'dry_types/dry_types'

      # NOTE: register dry-types type system
      SmartCore::Initializer::TypeSystem.register(
        :dry_types, SmartCore::Initializer::TypeSystem::DryTypes
      )
    end
  end
end
