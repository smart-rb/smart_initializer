# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute
  require_relative 'attribute/parameters'
  require_relative 'attribute/list'
  require_relative 'attribute/finalizer'
  require_relative 'attribute/definer'
  require_relative 'attribute/factory'

  # @since 0.1.0
  extend Forwardable

  # @return [Symbol]
  #
  # @pai private
  # @since 0.1.0
  def_delegator :parameters, :name

  # @return [SmartCore::Types::Primitive]
  #
  # @pai private
  # @since 0.1.0
  def_delegator :parameters, :type

  # @return [Symbol]
  #
  # @pai private
  # @since 0.1.0
  def_delegator :parameters, :privacy

  # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
  #
  # @pai private
  # @since 0.1.0
  def_delegator :parameters, :finalizer

  # @return [Boolean]
  #
  # @pai private
  # @since 0.1.0
  def_delegators :parameters, :cast, :cast?

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def_delegator :parameters, :default

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def_delegator :parameters, :has_default?

  # @param name [Symbol]
  # @param type [SmartCore::Types::Primitive]
  # @param privacy [Symbol]
  # @param finalizer [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
  # @param cast [Boolean]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, type, privacy, finalizer, cast, dynamic_options)
    @parameters = SmartCore::Initializer::Attribute::Parameters.new(
      name, type, privacy, finalizer, cast, dynamic_options
    )
  end

  # @return [SmartCore::Initializer::Attribute]
  #
  # @api private
  # @since 0.1.0
  def dup
    self.class.new(
      parameters.name.dup,
      parameters.type,
      parameters.privacy,
      parameters.finalizer.dup,
      parameters.cast,
      parameters.dynamic_options.dup
    )
  end

  private

  # @return [SmartCore::Initializer::Attribute::Parameters]
  #
  # @api private
  # @since 0.1.0
  attr_reader :parameters
end
