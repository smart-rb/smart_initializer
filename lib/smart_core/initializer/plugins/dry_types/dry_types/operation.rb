# frozen_string_literal: true

module SmartCore::Initializer::TypeSystem
  # @api private
  # @since 0.3.4
  module DryTypes::Operation
    require_relative 'operation/base'
    require_relative 'operation/valid'
    require_relative 'operation/validate'
    require_relative 'operation/cast'
  end
end
