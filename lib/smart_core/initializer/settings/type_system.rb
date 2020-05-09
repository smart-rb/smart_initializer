# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Settings::TypeSystem
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @type_system = nil
    @lock = SmartCore::Engine::Lock.new
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def generic_type_object
    thread_safe do
      SmartCore::Initializer::TypeSystem.resolve(resolve).generic_type_object
    end
  end

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def resolve
    thread_safe do
      @type_system || SmartCore::Initializer::Configuration.config[:default_type_system]
    end
  end

  # @param value [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def assign(value)
    thread_safe do
      SmartCore::Initializer::TypeSystem.resolve(value) # NOTE: type system existence validation
      @type_system = value
    end
  end

  # @return [SmartCore::Initializer::Settings::TypeSystem]
  #
  # @api private
  # @since 0.1.0
  def dup
    thread_safe do
      self.class.new.tap do |duplicate|
        duplicate.instance_variable_set(:@type_system, @type_system)
      end
    end
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
