# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Parameters
  require_relative 'parameters/factory'

  # @param name [String, Symbol]
  # @param type [String, Symbol, SmartCore::Types::Primitive]
  # @param privacy [String, Symbol]
  # @param finalizer [String, Symbol, Proc]
  # @param cast [Boolean]
  # @param dynamic [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, type, privacy, finalizer, cast, dynamic)
  end
end
