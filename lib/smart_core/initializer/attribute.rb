# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute
  require_relative 'attribute/options'
  require_relative 'attribute/list'

  # @return [SmartCore::Initializer::Attribute::Options]
  #
  # @api private
  # @since 0.1.0
  attr_reader :options

  # @param name [String, Symbol]
  # @param type [Symbol, String, SmartCore::Types::Primitive]
  # @param privacy [String, Symbol]
  # @option final [Proc]
  # @option cast [Boolean]
  # @option dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, type, privacy, final:, cast:, **dynamic_options)
    @options = SmartCore::Initializer::Attribute::Options.new(
      name: name, type: type, final: final, cast: cast, dynamic: dynamic_options
    )
  end
end
