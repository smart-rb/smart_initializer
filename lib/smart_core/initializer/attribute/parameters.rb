# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Parameters
  require_relative 'parameters/factory'

  class << self
    # @option name [String, Symbol]
    # @option type [String, Symbol, SmartCore::Types::Primitive]
    # @option privacy [String, Symbol]
    # @option finalizer [String, Symbol, Proc]
    # @option cast [Boolean]
    # @option dynamic [Hash<Symbol,Any>]
    # @return [SmartCore::Initializer::Attribute::Parameters]
    #
    # @api private
    # @since 0.1.0
    def create(name:, type:, privacy:, finalizer:, cast:, dynamic:)
      Factory.create(
        name: name,
        type: type,
        privacy: privacy,
        finalizer: finalizer,
        cast: cast,
        dynamic: dynamic
      )
    end
  end

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
