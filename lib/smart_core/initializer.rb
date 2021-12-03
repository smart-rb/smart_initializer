# frozen_string_literal: true

require 'smart_core'
require 'smart_core/types'
require 'forwardable'

# @api public
# @since 0.1.0
module SmartCore
  # @api public
  # @since 0.1.0
  module Initializer
    require_relative 'initializer/version'
    require_relative 'initializer/errors'
    require_relative 'initializer/plugins'
    require_relative 'initializer/settings'
    require_relative 'initializer/configuration'
    require_relative 'initializer/type_system'
    require_relative 'initializer/attribute'
    require_relative 'initializer/extensions'
    require_relative 'initializer/constructor'
    require_relative 'initializer/dsl'
    require_relative 'initializer/instance_attribute_accessing'
    require_relative 'initializer/functionality'

    class << self
      # @param base_klass [Class]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      # @version 0.3.0
      def included(base_klass)
        ::SmartCore::Initializer::Functionality.seed_to(base_klass)
      end
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(*); end
  end

  class << self
    # @option type_system [String, Symbol]
    # @option strict_options [Boolean]
    # @option auto_cast [Boolean]
    # @return [Module]
    #
    # @api public
    # @since 0.1.0
    # @version 0.8.0
    # rubocop:disable Naming/MethodName
    def Initializer(
      type_system: SmartCore::Initializer::Configuration[:default_type_system],
      strict_options: SmartCore::Initializer::Configuration[:strict_options],
      auto_cast: SmartCore::Initializer::Configuration[:auto_cast]
    )
      SmartCore::Initializer::Functionality.includable_module(
        type_system: type_system,
        strict_options: strict_options,
        auto_cast: auto_cast
      )
    end
    # rubocop:enable Naming/MethodName
  end
end
