# frozen_string_literal: true

# @abstract
# @api private
# @since 0.1.0
class SmartCore::Initializer::TypeSystem::Interop::Operation
  # @param type [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(type)
    @type = type
  end

  # @param value [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def call(value); end

  private

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type
end
