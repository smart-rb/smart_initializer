# frozen_string_literal: true

# @api private
# @since 0.8.0
# @version 0.11.0
class SmartCore::Initializer::Attribute::Value::Base
  # @return [Hash<Symbol,Symbol>]
  #
  # @api private
  # @since 0.8.0
  PRIVACY_MODES = {
    public:    :public,
    protected: :protected,
    private:   :private
  }.freeze

  # @return [Symbol]
  #
  # @api private
  # @since 0.8.0
  DEFAULT_PRIVACY_MODE = PRIVACY_MODES[:public]

  # @return [Proc]
  #
  # @api private
  # @since 0.8.0
  DEFAULT_FINALIZER = proc { |value| value }.freeze

  # @return [NilClass]
  #
  # @api private
  # @since 0.8.0
  DEFAULT_AS = nil

  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  DEFAULT_MUTABLE = false

  # @return [Class]
  #
  # @api private
  # @since 0.12.0
  attr_reader :klass

  # @return [Symbol]
  #
  # @api private
  # @since 0.8.0
  attr_reader :name

  # @return [SmartCore::Initializer::TypeSystem::Interop]
  #
  # @api private
  # @since 0.8.0
  attr_reader :type

  # @return [Class<SmartCore::Initilizer::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.8.0
  attr_reader :type_system

  # @return [Symbol]
  #
  # @api private
  # @since 0.8.0
  attr_reader :privacy

  # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock]
  # @return [SmartCore::Initializer::Attribute::Finalizer::InstanceMethod]
  #
  # @api private
  # @since 0.8.0
  attr_reader :finalizer

  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  attr_reader :cast
  alias_method :cast?, :cast

  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  attr_reader :mutable
  alias_method :mutable?, :mutable

  # @return [String, Symbol, NilClass]
  #
  # @api private
  # @since 0.8.0
  attr_reader :as

  # @param klass [Class]
  # @param name [Symbol]
  # @param type [SmartCore::Initializer::TypeSystem::Interop]
  # @param type_system [Class<SmartCore::Initializer::TypeSystem::Interop>]
  # @param privacy [Symbol]
  # @param finalizer [SmartCore::Initializer::Attribute::AnonymousBlock/InstanceMethod]
  # @param cast [Boolean]
  # @param mutable [Boolean]
  # @param as [NilClass, Symbol, String]
  # @return [void]
  #
  # @api private
  # @since 0.8.0
  def initialize(klass, name, type, type_system, privacy, finalizer, cast, mutable, as)
    @klass = klass
    @name = name
    @type = type
    @type_system = type_system
    @privacy = privacy
    @finalizer = finalizer
    @cast = cast
    @mutable = mutable
    @as = as
  end

  # @param value [Any]
  # @return [void]
  #
  # @raise [SmartCore::Initializer::IncorrectTypeError]
  #
  # @api private
  # @since 0.8.0
  # @version 0.11.0
  def validate!(value)
    unless type.valid?(value)
      raise(
        SmartCore::Initializer::IncorrectTypeError,
        "Validation of attribute `#{klass}##{name}` failed. " \
        "Expected: #{type.identifier}, got: #{truncate(value.inspect, 100)}",
      )
    end
  end

  private

  def truncate(string, length)
    return string unless string.size > length
    omission = "..."
    "#{string[0, string.size - omission.size]}#{omission}"
  end
end
