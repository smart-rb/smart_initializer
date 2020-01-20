# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::DSL
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_eval do
        instance_variable_set(:@__params__,  SmartCore::Initializer::Attribute::List.new)
        instance_variable_set(:@__options__, SmartCore::Initializer::Attribute::List.new)
      end

      base_klass.extend(ClassMethods)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [SmartCore::Initializer::Attribute::List]
    #
    # @api private
    # @since 0.1.0
    def __params__
      @__params__
    end

    # @return [SmartCore::Initializer::Attribute::List]
    #
    # @api private
    # @since 0.1.0
    def __options__
      @__options__
    end
  end
end
