# frozen_string_literal: true

# @pai private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Finalizer::NonMutating
  # @param finalizer [NilClass, Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(finalizer = nil)
    @finalizer = nil
  end

  # @param value [Any]
  # @param isntance [Any]
  # @return [value]
  #
  # @pai private
  # @since 0.1.0
  def call(value, instance)
    value
  end

  private

  # @return [NilClass, Any]
  #
  # @api private
  # @since 0.1.0
  attr_reader :finalizer
end
