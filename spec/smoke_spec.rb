# frozen_string_literal: true

RSpec.describe 'Smoke Test' do
  specify 'full definition' do
    class User
      include SmartCore::Initializer
      # include SmartCore::Types::System(:T)
      # param :test, T::Value::Integer

      param :user_id, SmartCore::Types::Value::Integer,
            cast: true, default: 'test', privacy: :private
      option :password, :integer, cast: true, default: 'test', privacy: :private
      option :keka, finalize: (-> (value) { value.to_s })

      params :creds, :nickname
      options :metadata, :datameta

      def initialize(*attrs, &block)
        @attrs = attrs
        @block = block
      end

      attr_reader :attrs
      attr_reader :block
    end

    random_block_result = rand(1...1000)
    user = User.new(
      1, { admin: true }, '0exp', password: 'kek', metadata: {}, datameta: {}, keka: 123
    ) { random_block_result }

    expect(user).to be_a(User)

    expect { user.user_id }.to raise_error(NoMethodError)
    expect(user.send(:user_id)).to eq(1)
    expect(user.creds).to eq(admin: true)
    expect(user.nickname).to eq('0exp')
    expect { user.password }.to raise_error(NoMethodError)
    expect(user.send(:password)).to eq(0)
    expect(user.metadata).to eq({})
    expect(user.datameta).to eq({})
    expect(user.keka).to eq('123')

    expect(user.attrs).to eq(
      [1, { admin: true }, '0exp',
       { password: 'kek', metadata: {}, datameta: {}, keka: 123 }]
    )

    expect(user.block).to be_a(Proc)
    expect(user.block.call).to eq(random_block_result)
  end

  specify 'type alias shadowing warn' do
    expect do
      SmartCore::Initializer::TypeSystem::SmartTypes.type_alias(
        :string, SmartCore::Types::Value::String
      )
    end.to output(
      '[SmartCore::Initializer::TypeSystem::SmartTypes] ' \
      'Shadowing of the already existing "string" type alias.'
    ).to_stderr

    expect do
      SmartCore::Initializer::TypeSystem::SmartTypes.type_alias(
        :integer, SmartCore::Types::Value::Integer
      )
    end.to output(
      '[SmartCore::Initializer::TypeSystem::SmartTypes] ' \
      'Shadowing of the already existing "integer" type alias.'
    ).to_stderr
  end

  specify 'inheritance' do
    class NanoBase
      include SmartCore::Initializer

      param :a
      option :b

      params :c, :d, :e
      options :f, :g
    end

    Concrete = Class.new(NanoBase)
    SubConcrete = Class.new(Concrete)
    sub_concrete = SubConcrete.new(1, 2, 3, 4, b: 6, f: 7, g: 8)

    expect(sub_concrete.a).to eq(1)
    expect(sub_concrete.b).to eq(6)
    expect(sub_concrete.c).to eq(2)
    expect(sub_concrete.d).to eq(3)
    expect(sub_concrete.e).to eq(4)
    expect(sub_concrete.f).to eq(7)
    expect(sub_concrete.g).to eq(8)
  end

  specify 'type aliases' do
    class Animal
      include SmartCore::Initializer

      param :name, :string
      option :age, :integer
    end

    expect { Animal.new(123, age: 123) }
      .to raise_error(SmartCore::Initializer::IncorrectTypeError)
    expect { Animal.new('test', age: 'test') }
      .to raise_error(SmartCore::Initializer::IncorrectTypeError)
    expect { Animal.new('test', age: 123) }.not_to raise_error
  end

  specify 'param and option overlapping' do
    expect do
      Class.new do
        include SmartCore::Initializer

        param :user_id
        option :user_id
      end
    end.to raise_error(SmartCore::Initializer::ParameterOverlapError)

    expect do
      Class.new do
        include SmartCore::Initializer

        option :user_id
        param :user_id
      end
    end.to raise_error(SmartCore::Initializer::OptionOverlapError)
  end

  it 'instantiation: fails on unknown options' do
    klass = Class.new do
      include SmartCore::Initializer
      option :user_id
      option :role_id, default: 123
    end

    expect do
      klass.new(user_id: 7, lol_kek: 123)
    end.to raise_error(SmartCore::Initializer::OptionArgumentError)

    expect do
      klass.new(user_id: 7, role_id: 55, lol_kek: 123)
    end.to raise_error(SmartCore::Initializer::OptionArgumentError)

    expect { klass.new(user_id: 7) }.not_to raise_error

    expect { klass.new(user_id: 7, role_id: 7) }.not_to raise_error
  end

  specify 'initializer behavior extension' do
    instance = Class.new { include SmartCore::Initializer }
    expect(instance).not_to respond_to(:kek)

    instance = Class.new do
      include SmartCore::Initializer
      ext_init { |object| object.define_singleton_method(:kek) { 'pek' } }
    end.new

    expect(instance).to respond_to(:kek)
    expect(instance.kek).to eq('pek')
  end

  specify 'validation exception' do
    klass = Class.new do
      include SmartCore::Initializer

      param :user_id, SmartCore::Types::Value::Integer
    end

    expect { klass.new('1') }.to raise_error(
      SmartCore::Initializer::IncorrectTypeError,
      "Validation of attribute 'user_id' (Integer, got String) failed: Invalid type"
    )
  end
end
