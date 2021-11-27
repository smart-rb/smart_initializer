# frozen_string_literal: true

# @api private
# @since 0.8.0
class SmartCore::Initializer::Settings::StrictOptions
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  def initialize
    @strict_options = nil
    @lock = SmartCore::Engine::Lock.new
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  def resolve
    thread_safe do
      @strict_options || SmartCore::Initializer::Configuration.config[:strict_options]
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

      @strict_options = value
    end
  end

  # @return [SmartCore::Initializer::Settings::StrictOptions]
  #
  # @api private
  # @since 0.8.0
  def dup
    thread_safe do
      self.class.new.tap do |duplicate|
        duplicate.instance_variable_set(:@strict_options, @strict_options)
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
