# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api private
  # @since 0.1.0
  module ThyTypes::Operation
    require_relative 'operation/base'
    require_relative 'operation/valid'
    require_relative 'operation/validate'
    require_relative 'operation/cast'
  end
end
