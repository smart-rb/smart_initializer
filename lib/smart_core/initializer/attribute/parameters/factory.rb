# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Attribute::Parameters::Factory
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

    end
  end
end
