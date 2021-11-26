# frozen_string_literal: true

module SmartCore::Initializer::Attribute::Value
  # @api private
  # @since 0.8.0
  class Option < Base
    # @return [Object]
    #
    # @api private
    # @since 0.8.0
    UNEDFINED_DEFAULT_OPTION = ::Object.new.tap(&:freeze)

    # @param name [Symbol]
    # @param type [SmartCore::Initializer::TypeSystem::Interop]
    # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
    # @param privacy [Symbol]
    # @param finalizer [SmartCore::Initializer::Attribute::AnonymousBlock/InstanceMethod]
    # @param cast [Boolean]
    # @param mutable [Boolean]
    # @param as [NilClass, Symbol, String]
    # @param default [Proc, Any]
    # @return [void]
    #
    # @api private
    # @since 0.8.0
    def initialize(name, type, type_system, privacy, finalizer, cast, mutable, as, default)
      super(name, type, type_system, privacy, finalizer, cast, mutable, as)
      @default = default
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.8.0
    def has_default?
      !@default.equal?(UNEDFINED_DEFAULT_OPTION)
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
      ) if @default.equal?(UNEDFINED_DEFAULT_OPTION)

      @default.is_a?(Proc) ? @default.call : @default.dup
    end

    # @return [SmartCore::Initializer::Attribute::Value::Option]
    #
    # @api private
    # @since 0.8.0
    # rubocop:disable Metrics/AbcSize
    def dup
      default = @default.equal?(UNEDFINED_DEFAULT_OPTION) ? @default : @default.dup

      self.class.new(
        @name.dup,
        @type,
        @type_system,
        @privacy,
        @finalizer.dup,
        @cast,
        @mutable,
        @as,
        default
      )
    end
    # rubocop:enable Metrics/AbcSize
  end
end
