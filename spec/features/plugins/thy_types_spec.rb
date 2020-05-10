# frozen_string_literal: true

# TODO: RSpec.describe 'Plugins: thy_types', plugin: :thy_types do
RSpec.describe 'Plugins: thy_types' do
  before do
    require 'thy'
    SmartCore::Initializer::Configuration.plugin(:thy_types)
  end

  specify 'type alias list' do
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_aliases).to contain_exactly(
      'any',
      'nil',
      'string',
      'symbol',
      'integer',
      'float',
      'numeric',
      'boolean',
      'time',
      'date_time',
      'untyped_array',
      'untyped_hash'
    )

    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('any')).to(
      respond_to(:check)
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('nil')).to eq(
      Thy::Types::Nil
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('string')).to eq(
      Thy::Types::String
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('symbol')).to eq(
      Thy::Types::Symbol
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('integer')).to eq(
      Thy::Types::Integer
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('float')).to eq(
      Thy::Types::Float
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('numeric')).to eq(
      Thy::Types::Numeric
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('boolean')).to eq(
      Thy::Types::Boolean
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('time')).to eq(
      Thy::Types::Time
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('date_time')).to eq(
      Thy::Types::DateTime
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('untyped_array')).to eq(
      Thy::Types::UntypedArray
    )
    expect(SmartCore::Initializer::TypeSystem::ThyTypes.type_from_alias('untyped_hash')).to eq(
      Thy::Types::UntypedHash
    )
  end
end
