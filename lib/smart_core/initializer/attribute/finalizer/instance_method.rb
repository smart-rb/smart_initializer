# frozen_string_literal: true

# @pai private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Finalizer::InstanceMethod
  # @param finalizer [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(finalizer)
    @finalizer = finalizer
  end

  # @param value [Any]
  # @param isntance [Any]
  # @return [value]
  #
  # @pai private
  # @since 0.1.0
  def call(value, instance)
    isntance.send(finalizer, value)
  end

  private

  # @return [NilClass, Any]
  #
  # @api private
  # @since 0.1.0
  attr_reader :finalizer
end
