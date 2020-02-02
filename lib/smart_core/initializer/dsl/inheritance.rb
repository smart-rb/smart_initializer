# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::DSL::Inheritance
  class << self
    # @param base [Class]
    # @param child [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inherit(base:, child:)
      child.__params__.concat(base.__params__)
      child.__options__.concat(base.__options__)
      child.__init_extensions__.concat(base.__init_extensions__)
    end
  end
end
