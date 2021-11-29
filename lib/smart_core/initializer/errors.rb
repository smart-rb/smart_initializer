# frozen_string_literal: true

module SmartCore::Initializer
  # @api public
  # @since 0.1.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.8.0
  AttributeError = Class.new(Error)

  # @api public
  # @since 0.8.0
  UndefinedAttributeError = Class.new(AttributeError)

  # @api public
  # @since 0.1.0
  ParameterArgumentError = Class.new(ArgumentError)

  # @api public
  # @since 0.1.0
  OptionArgumentError = Class.new(ArgumentError)

  # @api public
  # @since 0.8.0
  SettingArgumentError = Class.new(ArgumentError)

  # @api public
  # @since 0.1.0
  NoDefaultValueError = Class.new(Error)

  # @api public
  # @since 0.1.0
  OptionOverlapError = Class.new(ArgumentError)

  # @api public
  # @since 0.1.0
  ParameterOverlapError = Class.new(ArgumentError)

  # @api public
  # @since 0.1.0
  NoTypeAliasError = Class.new(Error)

  # @api public
  # @since 0.1.0
  PluginError = Class.new(Error)

  # @api public
  # @since 0.1.0
  UnresolvedPluginDependencyError = Class.new(PluginError)

  # @api public
  # @since 0.1.0
  AlreadyRegisteredPluginError = Class.new(PluginError)

  # @api public
  # @since 0.1.0
  UnregisteredPluginError = Class.new(PluginError)

  # @api public
  # @since 0.1.0
  TypeSystemError = Class.new(Error)

  # @api public
  # @since 0.1.0
  TypeAliasNotFoundError = Class.new(TypeSystemError)

  # @api public
  # @since 0.1.0
  IncorrectTypeSystemInteropError = Class.new(TypeSystemError)

  # @api public
  # @since 0.1.0
  IncorrectTypeObjectError = Class.new(TypeSystemError)

  # @api public
  # @since 0.1.0
  UnsupportedTypeSystemError = Class.new(TypeSystemError)

  # @api public
  # @since 0.1.0
  UnsupportedTypeOperationError = Class.new(TypeSystemError)

  # @api public
  # @since 0.1.0
  TypeCastingUnsupportedError = Class.new(UnsupportedTypeOperationError)
end
