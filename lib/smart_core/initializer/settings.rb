# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Settings
  require_relative 'settings/type_system'
  require_relative 'settings/strict_options'
  require_relative 'settings/duplicator'

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def initialize
    @type_system = TypeSystem.new
    @strict_options = StrictOptions.new
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def generic_type_object
    @type_system.generic_type_object
  end

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def type_system
    @type_system.resolve
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  def strict_options
    @strict_options.resolve
  end

  # @param value [String, System]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def type_system=(value)
    @type_system.assign(value)
  end

  # @param value [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  def strict_options=(value)
    @strict_options.assign(value)
  end

  # @return [SmartCore::Initializer::Settings]
  #
  # @api private
  # @since 0.1.0
  def dup
    Duplicator.duplicate(self)
  end
end
