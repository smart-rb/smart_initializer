# frozen_string_literal: true

# @abstract
# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::Interop
  require_relative 'interop/operation'
  require_relative 'interop/abstract_factory'
  require_relative 'interop/aliasing'

  # @since 0.1.0
  include SmartCore::Initializer::TypeSystem::Interop::Aliasing

  class << self
    # @param type_object [Any]
    # @return [SmartCore::Initializer::TypeSystem::Interop]
    #
    # @api private
    # @since 0.1.0
    def create(type_object)
      self::AbstractFactory.create(type_object)
    end

    # @return [SmartCore::Initialiezr::TypeSystem::Interop]
    #
    # @api private
    # @since 0.1.0
    def generic_type_object
      self::AbstractFactory.generic_type_object
    end

    # @param type_object [Any]
    # @return [void]
    #
    # @raise [SmartCore::Initializer::IncorrectTypeObjectError]
    #
    # @api private
    # @since 0.1.0
    def prevent_incompatible_type!(type_object)
      self::AbstractFactory.prevent_incompatible_type!(type_object)
    end
  end

  # @param valid_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
  # @param validate_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
  # @param cast_op [SmartCore::Initializer::TypeSystem::Interop::Operation]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(valid_op, validate_op, cast_op, force_cast)
    @valid_op = valid_op
    @validate_op = validate_op
    @cast_op = cast_op
    @force_cast = force_cast
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
    validate_op.call(value)
  end

  # @param value [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def cast(value)
    cast_op.call(value)
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.4.1
  def force_cast?
    @force_cast
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
