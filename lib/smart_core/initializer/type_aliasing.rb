# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::TypeAliasing
  require_relative 'type_aliasing/alias_list'

  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def extended(base_klass)
      base_klass.instance_variable_set(:@__type_aliases__, AliasList.new)
      base_klass.extend(ClassMethods)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [SmartCore::Initializer::TypeAliasing::AliasList]
    #
    # @api private
    # @since 0.1.0
    def __type_aliases__
      @__type_aliases__
    end

    # @param alias_name [String, Symbol]
    # @param type [SmartCore::Types::Primitive]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def type_alias(alias_name, type)
      __type_aliases__.associate(alias_name, type)
    end

    # @param alias_name [String, Symbol]
    # @return [SmartCore::Types::Primitive]
    #
    # @api public
    # @since 0.1.0
    def type_from_alias(alias_name)
      __type_aliases__.resolve(alias_name)
    end
  end
end
