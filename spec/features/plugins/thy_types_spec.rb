# frozen_string_literal: true

RSpec.describe 'Plugins: thy_types', plugin: :thy_types do
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

  describe 'thy-types usage' do
    specify 'initializer with thy-types' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :thy_types)

        param :login, Thy::Types::String
        param :password, 'string'

        option :age, 'numeric'
        option :as_admin, Thy::Types::Boolean
      end

      instance = data_klass.new('vasia', 'pupkin', { age: 23, as_admin: true })

      expect(instance.login).to eq('vasia')
      expect(instance.password).to eq('pupkin')
      expect(instance.age).to eq(23)
      expect(instance.as_admin).to eq(true)
    end

    specify 'mixin thy-types with smart-types' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :thy_types)

        param :nickname, SmartCore::Types::Value::String, type_system: :smart_types
        param :password, Thy::Types::String

        option :balance, 'value.float', type_system: :smart_types
        option :version, 'float' # thy-types
      end

      instance = data_klass.new('over', 'watch', { balance: 12.34, version: 15.707 })

      expect(instance.nickname).to eq('over')
      expect(instance.password).to eq('watch')
      expect(instance.balance).to eq(12.34)
      expect(instance.version).to eq(15.707)
    end

    specify 'no support for type cast' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :thy_types)
        param :nickname, 'string', cast: true
      end

      expect do
        data_klass.new(123)
      end.to raise_error(SmartCore::Initializer::TypeCastingUnsupportedError)

      expect { data_klass.new('123') }.not_to raise_error
    end

    specify 'validation' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :thy_types)
        param :nickname, 'string'
        option :age, 'integer'
      end

      # NOTE: invalid
      expect { data_klass.new('test', { age: '123' }) }.to raise_error(
        SmartCore::Initializer::ThyTypeValidationError
      )

      # NOTE: invalid
      expect { data_klass.new(123, { age: 123 }) }.to raise_error(
        SmartCore::Initializer::ThyTypeValidationError
      )

      # NOTE: valid
      expect { data_klass.new('123', { age: 123 }) }.not_to raise_error
    end

    specify 'validation check for smart-types mixed with thy-types' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :thy_types)

        param :nickname, 'string', type_system: :smart_types
        param :email, 'string'
      end

      expect { data_klass.new(123, 'iamdaiver@gmail.com') }.to raise_error(
        SmartCore::Types::TypeError
      )

      expect { data_klass.new('123', :email) }.to raise_error(
        SmartCore::Initializer::ThyTypeValidationError
      )

      expect { data_klass.new('123', 'iamdaiver@gmail.com') }.not_to raise_error
    end
  end
end
