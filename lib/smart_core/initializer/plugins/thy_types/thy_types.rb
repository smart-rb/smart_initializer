# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api public
  # @since 0.1.0
  class ThyTypes < Interop
    require_relative 'thy_types/abstract_factory'
    require_relative 'thy_types/operation'

    type_alias(:any, AbstractFactory.generic_type_object)
    type_alias(:nil, ::Thy::Types::Nil)
    type_alias(:string, ::Thy::Types::String)
    type_alias(:symbol, ::Thy::Types::Symbol)
    type_alias(:integer, ::Thy::Types::Integer)
    type_alias(:float, ::Thy::Types::Float)
    type_alias(:numeric, ::Thy::Types::Numeric)
    type_alias(:boolean, ::Thy::Types::Boolean)
    type_alias(:time, ::Thy::Types::Time)
    type_alias(:date_time, ::Thy::Types::DateTime)
    type_alias(:untyped_array, ::Thy::Types::UntypedArray)
    type_alias(:untyped_hash, ::Thy::Types::UntypedHash)
  end
end
