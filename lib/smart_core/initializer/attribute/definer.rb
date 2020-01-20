# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Definer
  # @param klass [Class]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(klass)
    @klass = klass
    @lock = SmartCore::Engine::Lock.new
  end

  # @param name [String, Symbol]
  # @param type [String, Symbol, SmartCore::Types::Primitive]
  # @param cast [Boolean]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_parameter(name, type, cast, privacy, finalize, dynamic_options)
    thread_safe do
    end
  end

  # @param names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_parameters(*names)
    thread_safe do
    end
  end

  # @param name [String, Symbol]
  # @param type [String, Symbol, SmartCore::Types::Primitive]
  # @param cast [Boolean]
  # @param privacy [String, Symbol]
  # @param finalize [String, Symbol, Proc]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_parameter(name, type, cast, privacy, finalize, dynamic_options)
    thread_safe do
    end
  end

  # @param names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_options(*names)
    thread_safe do
    end
  end

  private

  # @return [Class]
  #
  # @api private
  # @since 0.1.0
  attr_reader :klass

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
