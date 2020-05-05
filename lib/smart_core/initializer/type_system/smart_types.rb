# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::SmartTypes < SmartCore::Initializer::TypeSystem::Interop
  require_relative 'smart_types/abstract_factory'
  require_relative 'smart_types/operation'

  type_alias('value.any',         SmartCore::Types::Value::Any)
  type_alias('value.nil',         SmartCore::Types::Value::Nil)
  type_alias('value.string',      SmartCore::Types::Value::String)
  type_alias('value.symbol',      SmartCore::Types::Value::Symbol)
  type_alias('value.text',        SmartCore::Types::Value::Text)
  type_alias('value.integer',     SmartCore::Types::Value::Integer)
  type_alias('value.float',       SmartCore::Types::Value::Float)
  type_alias('value.numeric',     SmartCore::Types::Value::Numeric)
  type_alias('value.big_decimal', SmartCore::Types::Value::BigDecimal)
  type_alias('value.boolean',     SmartCore::Types::Value::Boolean)
  type_alias('value.array',       SmartCore::Types::Value::Array)
  type_alias('value.hash',        SmartCore::Types::Value::Hash)
  type_alias('value.proc',        SmartCore::Types::Value::Proc)
  type_alias('value.class',       SmartCore::Types::Value::Class)
  type_alias('value.module',      SmartCore::Types::Value::Module)
  type_alias('value.tme',         SmartCore::Types::Value::Time)
  type_alias('value.date_time',   SmartCore::Types::Value::DateTime)
  type_alias('value.date',        SmartCore::Types::Value::Date)
  type_alias('value.time_based',  SmartCore::Types::Value::TimeBased)

  type_alias(:any,         SmartCore::Types::Value::Any)
  type_alias(:nil,         SmartCore::Types::Value::Nil)
  type_alias(:string,      SmartCore::Types::Value::String)
  type_alias(:symbol,      SmartCore::Types::Value::Symbol)
  type_alias(:text,        SmartCore::Types::Value::Text)
  type_alias(:integer,     SmartCore::Types::Value::Integer)
  type_alias(:float,       SmartCore::Types::Value::Float)
  type_alias(:numeric,     SmartCore::Types::Value::Numeric)
  type_alias(:big_decimal, SmartCore::Types::Value::BigDecimal)
  type_alias(:boolean,     SmartCore::Types::Value::Boolean)
  type_alias(:array,       SmartCore::Types::Value::Array)
  type_alias(:hash,        SmartCore::Types::Value::Hash)
  type_alias(:proc,        SmartCore::Types::Value::Proc)
  type_alias(:class,       SmartCore::Types::Value::Class)
  type_alias(:module,      SmartCore::Types::Value::Module)
  type_alias(:tme,         SmartCore::Types::Value::Time)
  type_alias(:date_time,   SmartCore::Types::Value::DateTime)
  type_alias(:date,        SmartCore::Types::Value::Date)
  type_alias(:time_based,  SmartCore::Types::Value::TimeBased)
end
