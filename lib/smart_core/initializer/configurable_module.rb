# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::ConfigurableModule
  # @return [NilClass]
  #
  # @api private
  # @since 0.1.0
  INITIAL_TYPE_SYSTEM = nil

  class << self
    # @param type_system [String, Symbol, NilClass]
    # @return [Module]
    #
    # @api private
    # @since 0.1.0
    def build(type_system: INITIAL_TYPE_SYSTEM)
      Module.new.tap do |extension|
        extension.singleton_class.define_method(:included) do |base_klass|
          base_klass.include(::SmartCore::Initializer)
          base_klass.__initializer_settings__.type_system = type_system
        end
      end
    end
  end
end
