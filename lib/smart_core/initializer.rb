# frozen_string_literal: true

require 'smart_core'

# @api public
# @since 0.1.0
module SmartCore::Initializer
  require_relative 'initializer/version'
  require_relative 'initializer/errors'
  require_relative 'initializer/attribute'
  require_relative 'initializer/dsl'

  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.include(SmartCore::Initializer::DSL)
    end
  end
end
