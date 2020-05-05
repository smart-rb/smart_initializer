# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::Interop
  require_relative 'interop/operation'
  require_relative 'interop/abstract_factory'

  # @param valid_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
  # @param validate_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
  # @param cast_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(valid_op, validate_op, cast_op)
    @valid = valid_op
    @validate = validate_op
    @cast = cast_op
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def valid?(value)
    valid_op.call(value)
  end

  # @param value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def validate!(value)
    validat_op.call(value)
  end

  # @param value [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def cast(value)
    cast_op.call(value)
  end

  private

  # @return [SmartCore::Initializer::TypeSystem::Interop::Operation]
  #
  # @api private
  # @since 0.1.0
  attr_reader :valid_op

  # @return [SmartCore::Initializer::TypeSystem::Interop::Operation]
  #
  # @api private
  # @since 0.1.0
  attr_reader :validate_op

  # @return [SmartCore::Initializer::TypeSystem::Interop::Operation]
  #
  # @api private
  # @since 0.1.0
  attr_reader :cast_op
end
