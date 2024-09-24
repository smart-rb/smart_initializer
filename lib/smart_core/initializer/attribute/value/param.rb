# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Value
  # @api private
  # @since 0.8.0
  class Param < Base
    # @return [SmartCore::Initializer::Attribute::Value::Param]
    #
    # @api private
    # @since 0.8.0
    def dup
      self.class.new(
        klass,
        name.dup,
        type,
        type_system,
        privacy,
        finalizer.dup,
        cast,
        mutable,
        as
      )
    end
  end
end
