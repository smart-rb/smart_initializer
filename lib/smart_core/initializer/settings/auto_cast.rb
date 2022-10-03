# frozen_string_literal: true

# @api private
# @since 0.8.0
# @version 0.10.0
class SmartCore::Initializer::Settings::AutoCast < SmartCore::Initializer::Settings::Base
  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  # @version 0.10.0
  def resolve
    @lock.read_sync do
      @value == nil ? SmartCore::Initializer::Configuration[:auto_cast] : @value
    end
  end

  # @param value [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  # @version 0.10.0
  def assign(value)
    @lock.write_sync do
      raise(
        SmartCore::Initializer::SettingArgumentError,
        ":auto_cast setting should be a type of boolean (got: `#{value.class}`)"
      ) unless value.is_a?(::TrueClass) || value.is_a?(::FalseClass)

      @value = value
    end
  end
end
