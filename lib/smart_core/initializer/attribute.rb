# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Initializer::Attribute
  require_relative 'attribute/parameters'
  require_relative 'attribute/list'
  require_relative 'attribute/finalizer'
  require_relative 'attribute/definer'

  # @return [Hash<Symbol,Symbol>]
  #
  # @api private
  # @since 0.1.0
  PRIVACY_MODES = {
    public:    :public,
    protected: :protected,
    private:   :private,
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

  # @return [SmartCore::Initializer::Attribute::Parameters]
  #
  # @api private
  # @since 0.1.0
  attr_reader :parameters

  # @option name [String, Symbol]
  # @option type [String, Symbol, SmartCore::Types::Primitive]
  # @option privacy [String, Symbol]
  # @option final [Proc]
  # @option cast [Boolean]
  # @param dynamic_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name:, type:, privacy:, final:, cast:, **dynamic_options)
    @options = SmartCore::Initializer::Attribute::Parameters::Factory.create(
      name:    name,
      type:    type,
      privacy: privacy,
      final:   final,
      cast:    cast,
      dynamic: dynamic_options
    )
  end
end
