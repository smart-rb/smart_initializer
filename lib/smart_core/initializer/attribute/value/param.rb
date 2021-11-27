# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Value
  # @api private
  # @since 0.8.0
  class Param < Base
    # @return [SmartCore::Initializer::Attribute::Value::Param]
    #
    # @api private
    # @since 0.8.0
    # rubocop:disable Metrics/AbcSize
    def dup
      self.class.new(
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
    # rubocop:enable Metrics/AbcSize
  end
end
