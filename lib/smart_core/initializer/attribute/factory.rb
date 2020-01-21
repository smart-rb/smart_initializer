# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Factory
  class << self
    # @param name [String, Symbol]
    # @param type [String, Symbol, SmartCore::Types::Primitive]
    # @param privacy [String, Symbol]
    # @param finalize [String, Symbol, Proc]
    # @param cast [Boolean]
    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [SmartCore::Initializer::Attribute]
    #
    # @api private
    # @since 0.1.0
    def create(name, type,  privacy, finalize, cast, dynamic_options)
      name = prepare_name_param(name)
      type = prepare_type_param(type)
      privacy = prepare_privacy_param(privacy)
      finalize = prepare_finalize_param(finalize)
      cast = prepare_cast_param(cast)
      dynamic_options = prepare_dynamic_options_param(dynamic_options)

      create_attribute(name, type, privacy, finalize, cast, dynamic_options)
    end

    private

    # @param name [String, Symbol]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def prepare_name_param(name)
    end

    # @param type [String, Symbol, SmartCore::Types::Primitive]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    def prepare_type_param(type)
    end

    # @param cast [Boolean]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def prepare_cast_param(cast)
    end

    # @param privacy [String, Symbol]
    # @return [Symbol]
    #
    # @api private
    # @since 0.1.0
    def prepare_privacy_param(privacy)
    end

    # @param finalize [String, Symbol, Proc]
    # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
    #
    # @api private
    # @since 0.1.0
    def prepare_finalize_param(finalize)
    end

    # @param dynamic_options [Hash<Symbol,Any>]
    # @return [Hash<Symbol,Any>]
    #
    # @api private
    # @since 0.1.0
    def prepare_dynamic_options_param(dynamic_options)
    end

    # @param name [String]
    # @param type [SmartCore::Types::Primitive]
    # @param privacy [Symbol]
    # @param finalize [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock/InstanceMethod]
    # @param cast [Boolean]
    # @param dynamic_options [Hash<Symbol,String>]
    # @return [SmartCore::Initializer::Attribute]
    #
    # @api private
    # @since 0.1.0
    def create_attribute(name, type, privacy, finalize, cast, dynamic_options)
      SmartCore::Initializer::Attribute.new(name, type, privacy, finalize, cast, dynamic_options)
    end
  end
end
