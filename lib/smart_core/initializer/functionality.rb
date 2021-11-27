# frozen_string_literal: true

# @api private
# @since 0.3.0
module SmartCore::Initializer::Functionality
  # @return [NilClass]
  #
  # @api private
  # @since 0.3.0
  INITIAL_TYPE_SYSTEM = nil

  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  STRICT_OPTIONS = true

  class << self
    # @option type_system [String, Symbol, NilClass]
    # @return [Module]
    #
    # @api private
    # @since 0.3.0
    # @version 0.8.0
    def includable_module(
      type_system: INITIAL_TYPE_SYSTEM,
      strict_options: STRICT_OPTIONS
    )
      Module.new.tap do |extension|
        extension.singleton_class.define_method(:included) do |base_klass|
          base_klass.include(::SmartCore::Initializer)
          base_klass.__initializer_settings__.type_system = type_system
          base_klass.__initializer_settings__.strict_options = strict_options
        end
      end
    end

    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    def seed_to(base_klass)
      base_klass.extend(SmartCore::Initializer::DSL)
      base_klass.include(SmartCore::Initializer::InstanceAttributeAccessing)
    end
  end
end
