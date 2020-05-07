# frozen_string_literal: true

# @api public
# @since 0.1.0
module SmartCore::Initializer::Configuration
  # @since 0.1.0
  include Qonfig::Configurable

  configuration do
    setting :default_type_system, :smart_types
  end
end
