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
    @lock = SmartCore::Engine::Lock.new
  end

  # @!method resolve
  #   @return [Any]

  # @!method assign(value)
  #   @param value [Any]
  #   @return [void]
  #   @raise [SmartCore::Initializer::SettingArgumentError]

  # @return [SmartCore::Initializer::Settings::Base]
  #
  # @api private
  # @since 0.8.0
  def dup
    thread_safe do
      self.class.new.tap do |duplicate|
        duplicate.instance_variable_set(:@value, @value)
      end
    end
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.8.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
