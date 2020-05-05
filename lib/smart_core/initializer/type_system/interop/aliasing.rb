# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Initializer::TypeSystem::Interop::Aliasing
  require_relative 'aliasing/alias_list'

  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.extend(ClassMethods)
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassInheritance
    # @param child_klass [Class<SmartCore::Initializer::TypeSystem::Interop>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inherited(child_klass)
      child_klass.instance_variable_set(:@__type_aliases__, AliasList.new(child_klass))
      super
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [SmartCore::Initializer::TypeSystem::Interop::Aliasing::AliasList]
    #
    # @api private
    # @since 0.1.0
    def __type_aliases__
      @__type_aliases__
    end

    # @param alias_name [String, Symbol]
    # @param type [Any]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def type_alias(alias_name, type)
      __type_aliases__.associate(alias_name, type)
    end

    # @param alias_name [String, Symbol]
    # @return [Any]
    #
    # @api public
    # @since 0.1.0
    def type_from_alias(alias_name)
      __type_aliases__.resolve(alias_name)
    end
  end
end
