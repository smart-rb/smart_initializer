# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute
  require_relative 'attribute/parameters'
  require_relative 'attribute/list'
  require_relative 'attribute/finalizer'
  require_relative 'attribute/factory'

  # @since 0.1.0
  extend ::Forwardable

  # @return [Symbol]
  #
  # @pai private
  # @since 0.1.0
  def_delegator :parameters, :name

  # @return [SmartCore::Initializer::TypeSystem::Interop]
  #
  # @pai private
  # @since 0.1.0
  def_delegator :parameters, :type

  # @return [Class<SmartCore::Initializer::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.1.0
  def_delegator :parameters, :type_system

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

  # @return [Boolean]
  #
  # @api private
  # @since 0.4.0
  def_delegator :parameters, :read_only

  # @return [String, Symbol, NilClass]
  #
  # @api private
  # @since 0.4.0
  def_delegator :parameters, :as

  # @param name [Symbol]
  # @param type [SmartCore::Initializer::TypeSystem::Interop]
  # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @param privacy [Symbol]
  # @param finalizer [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
  # @param cast [Boolean]
  # @param read_only [Boolean]
  # @param as [String, Symbol, NilClass]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, type, type_system, privacy, finalizer, cast, read_only, as, dynamic_options)
    @parameters = SmartCore::Initializer::Attribute::Parameters.new(
      name, type, type_system, privacy, finalizer, cast, read_only, as, dynamic_options
    )
  end

  # @param value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.5.1
  def validate!(value)
    type.validate!(value)
  rescue => error
    raise SmartCore::Initializer::IncorrectTypeError,
          "Validation of attribute '#{name}' (#{type.identifier}) failed: #{error.message}"
  end

  # @return [SmartCore::Initializer::Attribute]
  #
  # @api private
  # @since 0.1.0
  # rubocop:disable Metrics/AbcSize
  def dup
    self.class.new(
      parameters.name.dup,
      parameters.type,
      parameters.type_system,
      parameters.privacy,
      parameters.finalizer.dup,
      parameters.cast,
      parameters.read_only,
      parameters.as,
      parameters.dynamic_options.dup
    )
  end
  # rubocop:enable Metrics/AbcSize

  private

  # @return [SmartCore::Initializer::Attribute::Parameters]
  #
  # @api private
  # @since 0.1.0
  attr_reader :parameters
end
