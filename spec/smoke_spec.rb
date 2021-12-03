# frozen_string_literal: true

RSpec.describe 'Smoke Test' do
  specify 'full definition' do
    class User
      include SmartCore::Initializer
      # include SmartCore::Types::System(:T)
      # param :test, T::Value::Integer

      param :user_id, SmartCore::Types::Value::Integer, cast: true, privacy: :private
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

  context 'instantiation' do
    describe 'strict_options option' do
      context "when it's true" do
        let(:klass) do
          Class.new do
            include SmartCore::Initializer(strict_options: true)
            option :user_id
            option :role_id, default: 123
          end
        end

        specify 'fails on unknown options' do
          expect do
            klass.new(user_id: 7, lol_kek: 123)
          end.to raise_error(SmartCore::Initializer::OptionArgumentError)

          expect do
            klass.new(user_id: 7, role_id: 55, lol_kek: 123)
          end.to raise_error(SmartCore::Initializer::OptionArgumentError)

          expect { klass.new(user_id: 7) }.not_to raise_error

          expect { klass.new(user_id: 7, role_id: 7) }.not_to raise_error
        end
      end

      context "when it's false" do
        let(:klass) do
          Class.new do
            include SmartCore::Initializer(strict_options: false)
            option :user_id
            option :role_id, default: 123
          end
        end

        specify 'skips unknown options' do
          expect { klass.new(user_id: 7, lol_kek: 123) }.not_to raise_error
        end
      end
    end
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

  describe 'mutable attributes' do
    # rubocop:disable Naming/VariableNumber
    specify 'attribute definition' do
      klass = Class.new do
        include SmartCore::Initializer

        param :a, 'string', mutable: true, cast: true
        param :b, 'integer', mutable: false
        param :c, 'array' # mutable: false by default

        option :d, :string, mutable: true
        option :e, :integer, mutable: false
        option :f, :array # mutable: false by default

        params :z1, :z2, mutable: true
        params :z3, :z4, mutable: false
        params :z5, :z6 # mutable: false by default

        options :o1, :o2,  mutable: true
        options :o3, :o4,  mutable: false
        options :o5, :o6 # mutable: false by default
      end

      instance = klass.new(
        1, 2, [],
        'z1', 'z2', 'z3', 'z4', 'z5', 'z6',
        d: '3', e: 4, f: [],
        o1: 'o1', o2: 'o2', o3: 'o3', o4: 'o4', o5: 'o5', o6: 'o6'
      )

      # check param behavior
      aggregate_failures 'param mutator behavior' do
        expect { instance.a = '2' }.not_to raise_error
        # test that value was changed
        expect(instance.a).to eq('2')
        # test the type checking of mutable methods
        expect { instance.a = 2 }.to raise_error(SmartCore::Initializer::IncorrectTypeError)
        # NOTE: old version of error => SmartCore::Types::TypeError

        # non-mutable option
        expect { instance.b = 3 }.to raise_error(::NoMethodError)
        # non-mutable by default
        expect { instance.c = [123] }.to raise_error(::NoMethodError)

        # after all manipulations the state is correct
        expect(instance.a).to eq('2')
        expect(instance.b).to eq(2)
        expect(instance.c).to eq([])
      end

      # check option behavior
      aggregate_failures 'otpion mutator behavior' do
        expect { instance.d = '2' }.not_to raise_error
        # test that value was changed
        expect(instance.d).to eq('2')
        # test the type checking of mutable methods
        expect { instance.d = 2 }.to raise_error(SmartCore::Initializer::IncorrectTypeError)
        # NOTE: old version of error => SmartCore::Types::TypeError

        # non-mutable option
        expect { instance.e = 3 }.to raise_error(::NoMethodError)
        # non-mutable by default
        expect { instance.f = [123] }.to raise_error(::NoMethodError)

        # after all manipulations the state is correct
        expect(instance.d).to eq('2')
        expect(instance.e).to eq(4)
        expect(instance.f).to eq([])
      end

      # check optionS behavior
      aggregate_failures 'optionS mutator behavior' do
        # mutable options
        expect { instance.o1 = 'kek_o1' }.not_to raise_error
        expect { instance.o2 = 'kek_o2' }.not_to raise_error
        expect(instance.o1).to eq('kek_o1')
        expect(instance.o2).to eq('kek_o2')

        # non-mutable options
        expect { instance.o3 = 'kek_o1' }.to raise_error(::NoMethodError)
        expect { instance.o4 = 'kek_o2' }.to raise_error(::NoMethodError)
        expect(instance.o3).to eq('o3')
        expect(instance.o4).to eq('o4')

        # non-mutable by default
        expect { instance.o5 = 'kek_05' }.to raise_error(::NoMethodError)
        expect { instance.o6 = 'kek_06' }.to raise_error(::NoMethodError)
        expect(instance.o5).to eq('o5')
        expect(instance.o6).to eq('o6')
      end

      # check paramS behavior
      aggregate_failures 'paramS mutator behavior' do
        # mutable options
        expect { instance.z1 = 'lel_z1' }.not_to raise_error
        expect { instance.z2 = 'lel_z2' }.not_to raise_error
        expect(instance.z1).to eq('lel_z1')
        expect(instance.z2).to eq('lel_z2')

        # non-mutable options
        expect { instance.z3 = 'lel_z3' }.to raise_error(::NoMethodError)
        expect { instance.z4 = 'lel_z4' }.to raise_error(::NoMethodError)
        expect(instance.z3).to eq('z3')
        expect(instance.z4).to eq('z4')

        # non-mutable by default
        expect { instance.z5 = 'lel_z5' }.to raise_error(::NoMethodError)
        expect { instance.z6 = 'lel_z6' }.to raise_error(::NoMethodError)
        expect(instance.z5).to eq('z5')
        expect(instance.z6).to eq('z6')
      end
    end
    # rubocop:enable Naming/VariableNumber
  end
end
