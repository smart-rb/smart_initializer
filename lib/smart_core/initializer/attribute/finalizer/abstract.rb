# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Finalizer::Abstract
  # @param finalizer [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(finalizer)
    @finalizer = finalizer
  end

  # @param value [Any]
  # @param instance [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def call(value, instance)
    # :nocov:
    raise NoMethodError
    # :nocov:
  end

  # @return [SmartCore::Initializer::Attribute::Finalizer::Abstract]
  def dup
    self.class.new(finalizer)
  end

  private

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  attr_reader :finalizer
end
