# frozen_string_literal: true

require 'smart_core'
require 'smart_core/types'
require 'forwardable'

# @api public
# @since 0.1.0
module SmartCore
  class << self
    def Initializer()

    end
  end

  module Initializer
    require_relative 'initializer/version'
    require_relative 'initializer/errors'
    require_relative 'initializer/plugins'
    require_relative 'initializer/type_system'
    require_relative 'initializer/attribute'
    require_relative 'initializer/extensions'
    require_relative 'initializer/constructor'
    require_relative 'initializer/dsl'
    require_relative 'initializer/type_aliasing'

    # @api public
    # @since 0.1.0
    extend Plugins::AccessMixin

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

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(*); end

    type_alias(:nil,     SmartCore::Types::Value::Nil)
    type_alias(:string,  SmartCore::Types::Value::String)
    type_alias(:symbol,  SmartCore::Types::Value::Symbol)
    type_alias(:text,    SmartCore::Types::Value::Text)
    type_alias(:integer, SmartCore::Types::Value::Integer)
    type_alias(:float,   SmartCore::Types::Value::Float)
    type_alias(:numeric, SmartCore::Types::Value::Numeric)
    type_alias(:boolean, SmartCore::Types::Value::Boolean)
    type_alias(:array,   SmartCore::Types::Value::Array)
    type_alias(:hash,    SmartCore::Types::Value::Hash)
    type_alias(:proc,    SmartCore::Types::Value::Proc)
    type_alias(:class,   SmartCore::Types::Value::Class)
    type_alias(:module,  SmartCore::Types::Value::Module)
    type_alias(:any,     SmartCore::Types::Value::Any)
  end
end
