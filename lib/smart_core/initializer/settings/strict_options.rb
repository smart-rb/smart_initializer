# frozen_string_literal: true

# @api private
# @since 0.8.0
class SmartCore::Initializer::Settings::StrictOptions < SmartCore::Initializer::Settings::Base
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  def initialize
    @value = nil
    @lock = SmartCore::Engine::Lock.new
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  def resolve
    thread_safe do
      @value == nil ? SmartCore::Initializer::Configuration[:strict_options] : @value
    end
  end

  # @param value [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  def assign(value)
    thread_safe do
      raise(
        SmartCore::Initializer::SettingArgumentError,
        ":strict_options setting should be a type of boolean (got: `#{value.class}`)"
      ) unless value.is_a?(::TrueClass) || value.is_a?(::FalseClass)

      @value = value
    end
  end
end
