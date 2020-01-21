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

  # @retirn [String]
  #
  # @since 0.1.0
  # @version 0.1.0
  def_delegator :parameters, :name

  # @retirn [SmartCore::Types::Primitive]
  #
  # @since 0.1.0
  # @version 0.1.0
  def_delegator :parameters, :type

  # @retirn [Symbol]
  #
  # @since 0.1.0
  # @version 0.1.0
  def_delegator :parameters, :privacy

  # @retirn [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
  #
  # @since 0.1.0
  # @version 0.1.0
  def_delegator :parameters, :finalizer

  # @retirn [Boolean]
  #
  # @since 0.1.0
  # @version 0.1.0
  def_delegator :parameters, :cast

  # @param name [String]
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

  private

  # @return [SmartCore::Initializer::Attribute::Parameters]
  #
  # @api private
  # @since 0.1.0
  attr_reader :parameters
end
