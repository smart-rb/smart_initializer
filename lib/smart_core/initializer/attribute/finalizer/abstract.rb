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

  # @return [Boolean] whether this is the built-in identity finalizer
  #   (returns its argument untouched). Custom finalizers may transform or
  #   mutate the value, so callers must re-validate after invoking them.
  #
  # @api private
  # @since 0.12.1
  def default_identity?
    false
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
