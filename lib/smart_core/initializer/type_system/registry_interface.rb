# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::TypeSystem::RegistryInterface
  class << self
    # @param base_module [Class, Module]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def extended(base_module)
      base_module.instance_variable_set(
        :@registry, SmartCore::Initializer::TypeSystem::Registry.new
      )
      base_module.instance_variable_set(
        :@access_lock, SmartCore::Engine::Lock.new
      )
    end
  end

  # @option system_identifier [String, Symbol]
  # @option type [Any]
  # @return [SmartCore::Initializer::TypeSystem::Interop]
  #
  # @api private
  # @since 0.1.0
  def build_interop(system: system_identifier, type: type_object)
    thread_safe { registry.resolve(system_identifier).create(type_object) }
  end

  # @param identifier [String, Symbol]
  # @param interop_klass [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(identifier, interop_klass)
    thread_safe { registry.register(identifier, interop_klass) }
  end

  # @param identifier [String, Symbol]
  # @return [Class<SmartCore::Initializer::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.1.0
  def resolve(identifier)
    thread_safe { registry.resolve(identifier) }
  end
  alias_method :[], :resolve

  # @return [Array<String>]
  #
  # @api public
  # @since 0.1.0
  def names
    thread_safe { registry.names }
  end

  # @return [Array<Class<SmartCore::Initializer::TypeSystem::Interop>>]
  #
  # @api public
  # @since 0.1.0
  def systems
    thread_safe { registry.to_h }
  end

  # @param block [Block]
  # @yield [system_name, system_interop]
  #   @yieldparam system_name [String]
  #   @yieldparam system_interop [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @return [Enumerable]
  #
  # @api public
  # @since 0.1.0
  def each(&block)
    thread_safe { registry.each(&block) }
  end

  private

  # @return [SmartCore::Initializer::TypeSystem::Registry]
  #
  # @api private
  # @since 0.1.0
  attr_reader :registry

  # @return [SmartCore::Engine::Lock]
  #
  # @api private
  # @since 0.1.0
  attr_reader :access_lock

  # @param block [Block]
  # @return [Any]
  #
  # @api pribate
  # @since 0.1.0
  def thread_safe(&block)
    access_lock.synchronize(&block)
  end
end
