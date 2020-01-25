# frozen_string_literal: true

require 'smart_core'
require 'smart_core/types'

# @api public
# @since 0.1.0
module SmartCore::Initializer
  require_relative 'initializer/version'
  require_relative 'initializer/errors'
  require_relative 'initializer/attribute'
  require_relative 'initializer/constructor'
  require_relative 'initializer/dsl'
  require_relative 'initializer/type_aliasing'

  # @since 0.1.0
  extend SmartCore::Initializer::TypeAliasing

  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.extend(SmartCore::Initializer::DSL)
    end
  end

  # @since 0.1.0
  type_alias(:nil, SmartCore::Types::Value::Nil)
  # @since 0.1.0
  type_alias(:string, SmartCore::Types::Value::String)
  # @since 0.1.0
  type_alias(:symbol, SmartCore::Types::Value::Symbol)
  # @since 0.1.0
  type_alias(:text, SmartCore::Types::Value::Text)
  # @since 0.1.0
  type_alias(:integer, SmartCore::Types::Value::Integer)
  # @since 0.1.0
  type_alias(:float, SmartCore::Types::Value::Float)
  # @since 0.1.0
  type_alias(:numeric, SmartCore::Types::Value::Numeric)
  # @since 0.1.0
  type_alias(:boolean, SmartCore::Types::Value::Boolean)
  # @since 0.1.0
  type_alias(:array, SmartCore::Types::Value::Array)
  # @since 0.1.0
  type_alias(:hash, SmartCore::Types::Value::Hash)
  # @since 0.1.0
  type_alias(:proc, SmartCore::Types::Value::Proc)
  # @since 0.1.0
  type_alias(:class, SmartCore::Types::Value::Class)
  # @since 0.1.0
  type_alias(:module, SmartCore::Types::Value::Module)
  # @since 0.1.0
  type_alias(:any, SmartCore::Types::Value::Any)
end
