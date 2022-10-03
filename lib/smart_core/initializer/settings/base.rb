# frozen_string_literal: true

# @api private
# @since 0.8.0
class SmartCore::Initializer::Settings::Base
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  def initialize
    @value = nil
    @lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @!method resolve
  #   @return [Any]
  #   @api private
  #   @since 0.8.0

  # @!method assign(value)
  #   @param value [Any]
  #   @return [void]
  #   @raise [SmartCore::Initializer::SettingArgumentError]
  #   @api private
  #   @since 0.8.0

  # @return [SmartCore::Initializer::Settings::Base]
  #
  # @api private
  # @since 0.8.0
  def dup
    @lock.write_sync do
      self.class.new.tap do |duplicate|
        duplicate.instance_variable_set(:@value, @value)
      end
    end
  end
end
