include SmartCore::Initializer(type_system: :dry_types)

SmartCore::Operation.configure do |config|
  config.initializer.default_type_system = :smart_types
end

SmartCore::Initializer.configure(:initializer) do |config|
  config.default_type_system = :smart_types
end

SmartCore::Initializer.plugin(:thy)
SmartCore::Initializer.plugin(:dry_types)

SmartCore::Initializer.configure(:smart_types) do |config|
  config.type_alias(:nil, SmartCore::Types::Value::Nil)
end

SmartCore::Initializer.configure(:thy) do |config|
end
