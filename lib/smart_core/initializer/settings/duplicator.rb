# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Settings::Duplicator
  class << self
    # @param settings [SmartCore::Initializer::Settings]
    # @return [SmartCore::Initializer::Settings]
    #
    # @api private
    # @since 0.1.0
    def duplicate(settings)
      SmartCore::Initializer::Settings.new.tap do |new_instance|
        type_system = settings.instance_variable_get(:@type_system).dup
        strict_options = settings.instance_variable_get(:@strict_options).dup
        auto_cast = settings.instance_variable_get(:@auto_cast).dup

        new_instance.instance_variable_set(:@type_system, type_system)
        new_instance.instance_variable_set(:@strict_options, strict_options)
        new_instance.instance_variable_set(:@auto_cast, auto_cast)
      end
    end
  end
end
