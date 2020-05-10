# frozen_string_literal: true

require 'qonfig'

# @api public
# @since 0.1.0
module SmartCore::Initializer::Configuration
  # @since 0.1.0
  include Qonfig::Configurable

  # @api public
  # @since 0.1.0
  extend SmartCore::Initializer::Plugins::AccessMixin

  class << self
    # @param setting_key [String, Symbol]
    # @return [Qonfig::Settings, Any]
    #
    # @api private
    # @since 0.1.0
    def [](setting_key)
      config[setting_key]
    end
  end

  # @since 0.1.0
  configuration do
    setting :default_type_system, :smart_types
    validate :default_type_system do |value|
      SmartCore::Initializer::TypeSystem.resolve(value) rescue false
    end
  end
end
