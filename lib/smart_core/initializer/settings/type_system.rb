# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.8.0
class SmartCore::Initializer::Settings::TypeSystem < SmartCore::Initializer::Settings::Base
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def initialize
    @value = nil
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
  # @version 0.8.0
  def resolve
    thread_safe do
      @value == nil ? SmartCore::Initializer::Configuration[:default_type_system] : @value
    end
  end

  # @param value [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def assign(value)
    thread_safe do
      # NOTE: type system existence validation
      SmartCore::Initializer::TypeSystem.resolve(value)
      @value = value
    end
  end
end
