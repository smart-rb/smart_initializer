# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api public
  # @since 0.3.4
  class DryTypes < Interop
    require_relative 'dry_types/abstract_factory'
    require_relative 'dry_types/operation'

    type_alias(:any, AbstractFactory.generic_type_object)
    type_alias(:nil, ::Dry::Types["nil"])
    type_alias(:string, ::Dry::Types["string"])
    type_alias(:symbol, ::Dry::Types["symbol"])
    type_alias(:integer, ::Dry::Types["integer"])
    type_alias(:float, ::Dry::Types["float"])
    type_alias(:decimal, ::Dry::Types["decimal"])
    type_alias(:boolean, ::Dry::Types["bool"])
    type_alias(:time, ::Dry::Types["time"])
    type_alias(:date_time, ::Dry::Types["date_time"])
    type_alias(:array, ::Dry::Types["array"])
    type_alias(:hash, ::Dry::Types["hash"])
  end
end
