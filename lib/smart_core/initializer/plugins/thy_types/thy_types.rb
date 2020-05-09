# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api public
  # @since 0.1.0
  class ThyTypes < Interop
    require_relative 'thy_types/abstract_factory'
    require_relative 'thy_types/operation'

    type_alias(:nil,       ::Thy::Nil)
    type_alias(:string,    ::Thy::String)
    type_alias(:symbol,    ::Thy::Symbol)
    type_alias(:integer,   ::Thy::Integer)
    type_alias(:float,     ::Thy::Float)
    type_alias(:numeric,   ::Thy::Numeric)
    type_alias(:boolean,   ::Thy::Boolean)
    type_alias(:tme,       ::Thy::Time)
    type_alias(:date_time, ::Thy::DateTime)
  end
end
