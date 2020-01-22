# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Constructor
  # @param klass [Class<SmartCore::Initializer>]
  # @param arguments [Array<Any>]
  # @param block [Proc, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(klass, arguments, block)
    @klass = klass
    @arguments = arguments
    @block = block
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def construct
    parameters, options = extract_arguments

    binding.irb

    klass.allocate
  end

  private

  # @return [Class]
  #
  # @api private
  # @since 0.1.0
  attr_reader :klass

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :arguments

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :block

  # @return [Array<Array<Any>,Hash<Symbol,Any>>]
  #
  # @api private
  # @since 0.1.0
  def extract_arguments
    <<~THINKING
      если klass.__options__.size == 0 - значит все идет в parameters
      если klass.__options__.size >= 1 И в arguments последний аттрибут - это хэш чисто с symbol'сами
        - послединй элемент летит как кварги
    THINKING

    parameters = []
    options = {}

    if klass.__options__.size >= 1 && arguments.last.is_a?(Hash) && arguments.last.keys.all? { |key| key.is_a?(Symbol) }
      parameters = arguments.size == 1 ? [] : arguments[0..-2]
      options = arguments.last
    else
      parameters = arguments.dup
    end

    [parameters, options]
  end
end
