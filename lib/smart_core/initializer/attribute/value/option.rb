# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Value
  # @api private
  # @since 0.8.0
  class Option < Base
    # @return [Object]
    #
    # @api private
    # @since 0.8.0
    UNDEFINED_DEFAULT = ::Object.new.tap(&:freeze)

    # @return [Boolean]
    #
    # @api private
    # @since 0.8.0
    DEFAULT_OPTIONAL = false

    # @return [Boolean]
    #
    # @api private
    # @since 0.8.0
    attr_reader :optional
    alias_method :optional?, :optional

    # @param klass [Class]
    # @param name [Symbol]
    # @param type [SmartCore::Initializer::TypeSystem::Interop]
    # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
    # @param privacy [Symbol]
    # @param finalizer [SmartCore::Initializer::Attribute::AnonymousBlock/InstanceMethod]
    # @param cast [Boolean]
    # @param mutable [Boolean]
    # @param as [NilClass, Symbol, String]
    # @param default [Proc, Any]
    # @param optional [Boolean]
    # @return [void]
    #
    # @api private
    # @since 0.8.0
    def initialize(
      klass,
      name,
      type,
      type_system,
      privacy,
      finalizer,
      cast,
      mutable,
      as,
      default,
      optional
    )
      super(klass, name, type, type_system, privacy, finalizer, cast, mutable, as)
      @default = default
      @optional = optional
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.8.0
    def has_default?
      !@default.equal?(UNDEFINED_DEFAULT)
    end

    # @return [Any]
    #
    # @raise [SmartCore::Initializer::NoDefaultValueError]
    #
    # @api private
    # @since 0.8.0
    def default
      raise(
        SmartCore::Initializer::NoDefaultValueError,
        "Attribute #{name} has no default value"
      ) if @default.equal?(UNDEFINED_DEFAULT)

      @default.is_a?(Proc) ? @default.call : @default.dup
    end

    # @return [SmartCore::Initializer::Attribute::Value::Option]
    #
    # @api private
    # @since 0.8.0
    def dup
      default = @default.equal?(UNDEFINED_DEFAULT) ? @default : @default.dup

      self.class.new(
        klass,
        name.dup,
        type,
        type_system,
        privacy,
        finalizer.dup,
        cast,
        mutable,
        as,
        default,
        optional
      )
    end
  end
end
