# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Options
  require_relative 'options/factory'

  # @param name [String]
  # @param type [SmartCore::Types::Primitive]
  # @param privacy [Symbol]
  # @param finalizer [SmartCore::Initializer::Attribute::Finalizer]
  # @param cast [Boolean]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, type, privacy, final, cast, **dynamic_options)
  end
end
