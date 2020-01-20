# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::Attribute::Options::Factory
  class << self
    # @param name [String, Symbol]
    # @param type [String, Symbol, SmartCore::Types::Primitive]
    # @param privacy [String, Symbol]
    # @param finalizer [String, Symbol, Proc]
    # @param cast [Boolean]
    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [SmartCore::Initializer::Attribute::Options]
    #
    # @api private
    # @since 0.1.0
    def create(name, type, privacy, finalizer, cast, dynamic_options)

    end
  end
end
