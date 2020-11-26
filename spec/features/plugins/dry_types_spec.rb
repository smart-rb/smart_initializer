# frozen_string_literal: true

RSpec.describe 'Plugins: dry_types', plugin: :dry_types do
  specify 'aliases' do
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_aliases).to contain_exactly(
      'any',
      'nil',
      'string',
      'symbol',
      'integer',
      'float',
      'decimal',
      'boolean',
      'time',
      'date_time',
      'array',
      'hash'
    )

    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('any')).to eq(
      Dry::Types["any"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('nil')).to eq(
      Dry::Types["nil"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('string')).to eq(
      Dry::Types["string"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('symbol')).to eq(
      Dry::Types["symbol"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('integer')).to eq(
      Dry::Types["integer"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('float')).to eq(
      Dry::Types["float"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('decimal')).to eq(
      Dry::Types["decimal"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('boolean')).to eq(
      Dry::Types["bool"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('time')).to eq(
      Dry::Types["time"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('date_time')).to eq(
      Dry::Types["date_time"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('array')).to eq(
      Dry::Types["array"]
    )
    expect(SmartCore::Initializer::TypeSystem::DryTypes.type_from_alias('hash')).to eq(
      Dry::Types["hash"]
    )
  end

  describe 'usage' do
    specify 'initializer with dry-types' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :dry_types)

        param :login, Dry::Types['string']
        param :password, 'string'

        option :age, 'integer'
        option :as_admin, Dry::Types['bool']
      end

      instance = data_klass.new('vasia', 'pupkin', { age: 23, as_admin: true })

      expect(instance.login).to eq('vasia')
      expect(instance.password).to eq('pupkin')
      expect(instance.age).to eq(23)
      expect(instance.as_admin).to eq(true)
    end

    specify 'mixing dry-types with smart-types' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :dry_types)

        param :nickname, SmartCore::Types::Value::String, type_system: :smart_types
        param :password, Dry::Types['string']

        option :balance, 'value.float', type_system: :smart_types
        option :version, 'float' # dry-types
      end

      instance = data_klass.new('over', 'watch', { balance: 12.34, version: 15.707 })

      expect(instance.nickname).to eq('over')
      expect(instance.password).to eq('watch')
      expect(instance.balance).to eq(12.34)
      expect(instance.version).to eq(15.707)
    end

    specify 'support for type casting with coercible types' do
      mod = Module.new do
        include Dry.Types(:coercible)
      end
      data_class = Class.new do
        include SmartCore::Initializer(type_system: :dry_types)
        param :nickname, mod::Coercible::String
      end

      instance = data_class.new(123)

      expect(instance.nickname).to eq('123')
    end

    specify 'validation' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :dry_types)
        param :nickname, 'string'
        option :age, 'integer'
      end

      # NOTE: invalid
      expect { data_klass.new('test', { age: '123' }) }.to raise_error(
        SmartCore::Initializer::DryTypeValidationError
      )

      # NOTE: invalid
      expect { data_klass.new(123, { age: 123 }) }.to raise_error(
        SmartCore::Initializer::DryTypeValidationError
      )

      # NOTE: valid
      expect { data_klass.new('123', { age: 123 }) }.not_to raise_error
    end

    specify 'validation check for smart-types mixed with dry-types' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :dry_types)

        param :nickname, 'string', type_system: :smart_types
        param :email, 'string'
      end

      expect { data_klass.new(123, 'iamdaiver@gmail.com') }.to raise_error(
        SmartCore::Types::TypeError
      )

      expect { data_klass.new('123', :email) }.to raise_error(
        SmartCore::Initializer::DryTypeValidationError
      )

      expect { data_klass.new('123', 'iamdaiver@gmail.com') }.not_to raise_error
    end

    specify 'support for the common attribute definition functionality' do
      data_klass = Class.new do
        include SmartCore::Initializer(type_system: :dry_types)

        option :email, 'string', default: 'no@email.com', finalize: -> (value) { "1#{value}" }
        option :admin, 'boolean', default: false, finalize: -> (value) { true }
      end

      instance = data_klass.new
      expect(instance.email).to eq('1no@email.com')
      expect(instance.admin).to eq(true)

      instance = data_klass.new(email: 'iamdaiver@gmail.com', admin: false)
      expect(instance.email).to eq('1iamdaiver@gmail.com')
      expect(instance.admin).to eq(true)
    end
  end
end
