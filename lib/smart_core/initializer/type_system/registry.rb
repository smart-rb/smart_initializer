# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::Registry
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @systems = {}
    @lock = SmartCore::Engine::Lock.new
  end

  # @param system_identifier [String, Symbol]
  # @param interop_klass [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(system_identifier, interop_klass)
    thread_safe { apply(system_identifier, interop_klass) }
  end

  # @param system_identifier [String, Symbol]
  # @return [Class<SmartCore::Initializer::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.1.0
  def resolve(system_identifier)
    thread_safe { fetch(system_identifier) }
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def names
    thread_safe { system_names }
  end

  # @return [Array<Class<SmartCore::Initializer::TypeSystem::Interop>>]
  #
  # @api private
  # @since 0.1.0
  def interops
    thread_safe { system_interops }
  end

  # @param block [Block]
  # @yield [system_name, system_interop]
  #   @yieldparam system_name [String]
  #   @yieldparam system_interop [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { iterate(&block) }
  end

  private

  # @return [Hash<String,Class<SmartCore::Initializer::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :systems

  # @return [Array<String>]
  #
  # @pai private
  # @since 0.1.0
  def system_names
    systems.keys
  end

  # @return [Array<Class<SmartCore::Initializer::TypeSystem::Interop>>]
  #
  # @api private
  # @since 0.1.0
  def system_interops
    systems.values
  end

  # @param block [Block]
  # @yield [system_name, system_interop]
  #   @yieldparam system_name [String]
  #   @yieldparam system_interop [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def iterate(&block)
    block_given? ? systems.each_pair(&block) : systems.each_pair
  end

  # @param system_identifier [String, Symbol]
  # @param interop_klass [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def apply(system_identifier, interop_klass)
    prevent_incorrect_system_interop!(interop_klass)
    identifier = indifferently_accessible_identifier(system_identifier)
    systems[identifier] = interop_klass
  end

  # @param system_identifier [String, Symbol]
  # @return [Class<SmartCore::Initializer::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.1.0
  def fetch(system_identifier)
    identifier = indifferently_accessible_identifier(system_identifier)

    unless registered?(identifier)
      raise(SmartCore::Initializer::UnsupportedTypeSystemError, <<~ERROR_MESSAGE)
        "#{identifier}" type system is not supported.
      ERROR_MESSAGE
    end

    systems.fetch(system_identifier)
  end

  # @param system_identifier [String, Symbol]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def registered?(system_identifier)
    identifier = indifferently_accessible_identifier(system_identifier)
    systems.key?(identifier)
  end

  # @param interop_klass [Class<SMartCore::Initializer::TypeSystem::Interop>]
  # @return [void]
  #
  # @raise [SmartCore::Initializer::IncorrectTypeSystemInteropError]
  #
  # @api private
  # @since 0.1.0
  def prevent_incorrect_system_interop!(interop_klass)
    unless interop_klass.is_a?(Class) && interop_klass < SmartCore::Initializer::TypeSystem::Interop
      raise(
        SmartCore::Initializer::IncorrectTypeSystemInteropError,
        'Incorrect type system interop class.'
      )
    end
  end

  # @param system_identifier [String, Symbol]
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def indifferently_accessible_identifier(system_identifier)
    system_identifier.to_s.clone.tap(&:freeze)
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
