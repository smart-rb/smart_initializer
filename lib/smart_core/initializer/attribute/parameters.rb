# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute::Parameters
  # @return [Hash<Symbol,Symbol>]
  #
  # @api private
  # @since 0.1.0
  PRIVACY_MODES = {
    public:    :public,
    protected: :protected,
    private:   :private
  }.freeze

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_PRIVACY_MODE = PRIVACY_MODES[:public]

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_CAST_BEHAVIOUR = false

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_FINALIZER = proc { |value| value }.freeze

  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_DYNAMIC_OPTIONS = {}.freeze

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :name

  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :privacy

  # @return [SmartCore::Initializer::Attribute::Finalizer::AnonymousBlock]
  # @return [SmartCore::Initializer::Attribute::Finalizer::InstanceMethod]
  #
  # @api private
  # @since 0.1.0
  attr_reader :finalizer

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  attr_reader :cast
  alias_method :cast?, :cast

  # @param name [Symbol]
  # @param type [SmartCore::Types::Primitive]
  # @param privacy [Symbol]
  # @param finalizer [SmartCore::Initializer::Attribute::AnonymousBlock/InstanceMethod]
  # @param cast [Boolean]
  # @param dynamic_options [Hash<Symbol,Any>]
  #   - :default - default value (Proc value will be called)
  #   - :memoize - (TODO)
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, type, privacy, finalizer, cast, dynamic_options)
    @name = name
    @type = type
    @privacy = privacy
    @finalizer = finalizer
    @cast = cast
    @dynamic_options = dynamic_options
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def has_default?
    dynamic_options.key?(:default)
  end

  # @return [Any]
  #
  # @raise [SmartCore::Initializer::NoDefaultValueError]
  #
  # @api private
  # @since 0.1.0
  def default
    default_value = dynamic_options.fetch(:default) do
      raise(SmartCore::Initializer::NoDefaultValueError, <<~ERROR_MESSAGE)
        Attribute #{name} has no default value
      ERROR_MESSAGE
    end

    defalut_value.is_a?(Proc) ? default_value.call : default_value
  end

  private

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :dynamic_options
end
