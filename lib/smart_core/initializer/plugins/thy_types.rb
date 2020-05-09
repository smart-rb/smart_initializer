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
        '::Thy does not exist or "thy" gme is not loaded'
      ) unless const_defined?('::Thy')

      require 'date'
      require_relative 'thy_types/errors'
      require_relative 'thy_types/thy_types'
    end
  end
end
