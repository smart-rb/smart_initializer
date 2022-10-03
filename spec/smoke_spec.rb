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
      option :send, :string, default: 'yes!' # you can use `send` as attribtue name

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
    expect(user.__send__(:user_id)).to eq(1)
    expect(user.creds).to eq(admin: true)
    expect(user.nickname).to eq('0exp')
    expect { user.password }.to raise_error(NoMethodError)
    expect(user.__send__(:password)).to eq(0)
    expect(user.metadata).to eq({})
    expect(user.datameta).to eq({})
    expect(user.keka).to eq('123')
    expect(user.send).to eq('yes!')

    expect(user.attrs).to eq(
      [1, { admin: true }, '0exp',
       { password: 'kek', metadata: {}, datameta: {}, keka: 123 }]
    )

    expect(user.block).to be_a(Proc)
    expect(user.block.call).to eq(random_block_result)
  end

  specify 'incompatible param/params/option/options names should raise an error' do
    expect do
      Class.new do
        include SmartCore::Initializer
        param 123
      end
    end.to raise_error(SmartCore::Initializer::ArgumentError)

    expect do
      Class.new do
        include SmartCore::Initializer
        option 123
      end
    end.to raise_error(SmartCore::Initializer::ArgumentError)

    expect do
      Class.new do
        include SmartCore::Initializer
        params :a, :b, 123, Object.new, 'test'
      end
    end.to raise_error(SmartCore::Initializer::ArgumentError)

    expect do
      Class.new do
        include SmartCore::Initializer
        options :a, :b, 123, Object.new, 'test'
      end
    end.to raise_error(SmartCore::Initializer::ArgumentError)
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

  specify 'invalid/unsupported type attribute' do
    expect do
      Class.new do
        include SmartCore::Initializer
        param :name, Object.new
      end
    end.to raise_error(SmartCore::Initializer::IncorrectTypeObjectError)

    expect do
      Class.new do
        include SmartCore::Initializer
        option :name, Object.new
      end
    end.to raise_error(SmartCore::Initializer::IncorrectTypeObjectError)

    expect do
      Class.new do
        include SmartCore::Initializer
        option :name, :my_custom_type_alias
      end
    end.to raise_error(SmartCore::Initializer::TypeAliasNotFoundError)

    expect do
      Class.new do
        include SmartCore::Initializer
        param :name, :my_custom_type_alias
      end
    end.to raise_error(SmartCore::Initializer::TypeAliasNotFoundError)
  end

  specify ':privacy attribute functionality' do
    aggregate_failures 'correct values amd fuctionality' do
      instance = Class.new do
        include SmartCore::Initializer

        param :a, privacy: :private
        param :b, privacy: :protected
        param :c, privacy: :public

        param :d, privacy: 'private'
        param :e, privacy: 'protected'
        param :g, privacy: 'public'

        params :a1, :a2, privacy: :private
        params :c1, :c2, privacy: :protected
        params :d1, :d2, privacy: :public

        params :a3, :a4, privacy: 'private'
        params :c3, :c4, privacy: 'protected'
        params :d3, :d4, privacy: 'public'

        option :o, privacy: :private
        option :p, privacy: :protected
        option :q, privacy: :public

        option :r, privacy: 'private'
        option :s, privacy: 'protected'
        option :t, privacy: 'public'

        options :x1, :x2, privacy: :private
        options :y1, :y2, privacy: :protected
        options :z1, :z2, privacy: :public

        options :x3, :x4, privacy: 'private'
        options :y3, :y4, privacy: 'protected'
        options :z3, :z4, privacy: 'public'
      end.new(
        '', '', '', '', '', '',
        '', '', '', '', '', '',
        '', '', '', '', '', '',
        o: 1, p: 1, q: 1, r: 1, s: 1, t: 1,
        x1: 1, x2: 1, x3: 1, x4: 1,
        y1: 1, y2: 1, y3: 1, y4: 1,
        z1: 1, z2: 1, z3: 1, z4: 1
      )

      expect(instance.private_methods(false)).to contain_exactly(*%i[
        a d a1 a2 a3 a4 o r x1 x2 x3 x4
      ])

      expect(instance.protected_methods(false)).to contain_exactly(*%i[
        b e c1 c2 c3 c4 p s y1 y2 y3 y4
      ])

      expect(instance.public_methods(false)).to contain_exactly(*%i[
        c g d1 d2 d3 d4 q t z1 z2 z3 z4
      ])
    end

    aggregate_failures 'incorrect values' do
      expect do
        Class.new do
          include SmartCore::Initializer
          param :name, privacy: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: PrivacyArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :name, privacy: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: PrivacyArgumentError
    end
  end
  describe ':finalize' do
    specify 'finalize the result value of attribute via instance method' do
      klass = Class.new do
        include SmartCore::Initializer

        param :x, 'numeric', finalize: :double_up
        param :y, 'boolean', finalize: :switch
        option :a, 'integer', finalize: :change_amount
        option :b, 'string', finalize: :post_process

        def double_up(attr_value)
          attr_value * 2
        end

        def switch(attr_value)
          !attr_value
        end

        def change_amount(attr_value)
          attr_value + 1000
        end

        def post_process(attr_value)
          "#{attr_value}_post_processed!"
        end
      end

      instance = klass.new(5.6, true, a: 20, b: 'daiver')
      expect(instance.x).to eq(11.2)
      expect(instance.y).to eq(false)
      expect(instance.a).to eq(1020)
      expect(instance.b).to eq('daiver_post_processed!')
    end

    specify 'finalize the result value of attribute via proc/lambda object' do
      klass = Class.new do
        include SmartCore::Initializer

        param :x, 'numeric', finalize: -> (val) { val * val }
        param :y, 'boolean', finalize: proc { |val| !val }
        option :a, 'integer', finalize: -> (val) { val + 1 }
        option :b, 'string', finalize: proc { 'NOPE! :D' }
      end

      instance = klass.new(10, false, a: 1, b: 'pek')

      expect(instance.x).to eq(100)
      expect(instance.y).to eq(true)
      expect(instance.a).to eq(2)
      expect(instance.b).to eq('NOPE! :D')
    end

    specify 'expects proc/labmda/string/symbol' do
      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, finalize: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: FinalizeArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, finalize: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: FinalizeArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, finalize: :test
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, finalize: 'test'
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, finalize: proc {}
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, finalize: -> (val) {}
        end
      end.not_to raise_error
    end

    specify 'lambda objects used for finalize should have an argument in their signature' do
      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, finalize: -> {}
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: FinalizeArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, finalize: -> {}
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: FinalizeArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, finalize: -> (val) {}
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, finalize: -> (val) {}
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, finalize: -> (*val) {}
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, finalize: -> (*val) {}
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, finalize: -> (req_arg, *val) {}
        end
      end.not_to raise_error

      # NOTE: proc objects can omit attribute in their signature
      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, finalize: proc {}
        end
      end.not_to raise_error
    end

    specify 'finalized return value is type-validated too' do
      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, 'string', finalize: -> (val) { 1 } # returns incorrect value
        end.new('111')
      end.to raise_error(SmartCore::Initializer::IncorrectTypeError)

      expect do
        Class.new do
          include SmartCore::Initializer
          option :b, 'string', finalize: proc { 1 } # returns incorrect value
        end.new(b: '111')
      end.to raise_error(SmartCore::Initializer::IncorrectTypeError)

      expect do
        Class.new do
          include SmartCore::Initializer
          param :c, :string, finalize: :post_process

          def post_process(attr_value)
            123
          end
        end.new('test')
      end.to raise_error(SmartCore::Initializer::IncorrectTypeError)

      expect do
        Class.new do
          include SmartCore::Initializer
          option :d, :string, finalize: :post_process

          def post_process(attr_value)
            123
          end
        end.new(d: 'test')
      end.to raise_error(SmartCore::Initializer::IncorrectTypeError)
    end
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
    aggregate_failures 'overlap failures' do
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
    expect(instance).not_to respond_to(:lol)

    instance = Class.new do
      include SmartCore::Initializer
      ext_init { |object| object.define_singleton_method(:kek) { 'pek' } }
      ext_init { |object| object.define_singleton_method(:lol) { 'rofl' } }
    end.new

    expect(instance).to respond_to(:kek)
    expect(instance).to respond_to(:lol)
    expect(instance.kek).to eq('pek')
    expect(instance.lol).to eq('rofl')
  end

  describe 'attribute aliases (:as)' do
    specify ':as option makes an alias method for attribute' do
      klass = Class.new do
        include SmartCore::Initializer

        param :name, as: :first_name
        option :nick, as: :login
      end

      instance = klass.new('Rustam', nick: :daiver)

      expect(instance.name).to eq('Rustam')
      expect(instance.first_name).to eq('Rustam')

      expect(instance.nick).to eq(:daiver)
      expect(instance.login).to eq(:daiver)
    end

    specify 'takes into original attribute incapsulation (private/protected/public)' do
      instance = Class.new do
        include SmartCore::Initializer

        param :a, as: :a1, privacy: :private, mutable: true
        param :b, as: :b1, privacy: :protected, mutable: true
        param :c, as: :c1, privacy: :public, mutable: true

        option :x, as: :x1, privacy: :private, mutable: true
        option :y, as: :y1, privacy: :protected, mutable: true
        option :z, as: :z1, privacy: :public, mutable: true
      end.new(1, 2, 3, x: 4, y: 5, z: 6)

      # rubocop:disable Layout/LineLength
      expect(instance.private_methods(false)).to contain_exactly(:a, :a=, :a1, :a1=, :x, :x=, :x1, :x1=)
      expect(instance.protected_methods(false)).to contain_exactly(:b, :b=, :b1, :b1=, :y, :y=, :y1, :y1=)
      expect(instance.public_methods(false)).to contain_exactly(:c, :c=, :c1, :c1=, :z, :z=, :z1, :z1=)
      # rubocop:enable Layout/LineLength
    end
    specify 'aliased mutable attributes gives type-validated mutator too' do
      klass = Class.new do
        include SmartCore::Initializer

        param :role, :symbol, as: :access_level, mutable: true
        option :nick, :string, as: :login, mutable: true
      end

      instance = klass.new(:admin, nick: 'D@iVeR')

      aggregate_failures 'instance repsonds to aliased mutators' do
        expect(instance).to respond_to(:access_level=)
        expect(instance).to respond_to(:login=)
      end

      aggregate_failures 'aliased mutator mutates attributes correctly' do
        expect(instance.access_level).to eq(:admin)
        expect(instance.role).to eq(:admin)
        expect(instance.login).to eq('D@iVeR')
        expect(instance.nick).to eq('D@iVeR')

        instance.access_level = :user
        instance.login = 'Rustam'

        expect(instance.access_level).to eq(:user)
        expect(instance.role).to eq(:user)
        expect(instance.login).to eq('Rustam')
        expect(instance.nick).to eq('Rustam')
      end

      aggregate_failures "incopmatible types raises error and does not mutate object's state" do
        expect do
          instance.access_level = 123
        end.to raise_error(SmartCore::Initializer::IncorrectTypeError)
        expect do
          instance.login = Object.new
        end.to raise_error(SmartCore::Initializer::IncorrectTypeError)

        # aliases
        expect(instance.access_level).to eq(:user)
        expect(instance.login).to eq('Rustam')

        # originals
        expect(instance.role).to eq(:user)
        expect(instance.nick).to eq('Rustam')
      end
    end

    specify 'expects strings and symbols' do
      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, as: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: use AliasArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, as: Object.new
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: use AliasArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, as: :test
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, as: 'test'
        end
      end.not_to raise_error
    end
  end

  describe 'optional `option` attributes' do
    specify 'developer can omit passing optional `option` attributes' do
      klass = Class.new do
        include SmartCore::Initializer

        param :name

        option :age, 'integer'
        option :role, 'symbol', optional: true
        option :nick, 'string', optional: true
        option :last_login_at, 'time'
      end

      # you can omit :role and :nick options
      instance = klass.new('Rustam', age: 30, last_login_at: Time.parse('2020-01-01'))

      expect(instance.name).to eq('Rustam')
      expect(instance.age).to eq(30)
      expect(instance.last_login_at).to eq(Time.parse('2020-01-01'))

      expect(instance.role).to eq(nil)
      expect(instance.nick).to eq(nil)
    end

    specify 'omitted attributes are initialized by `nil` by default' do
      instance = Class.new do
        include SmartCore::Initializer

        params :x, :y

        option :a, 'integer'
        option :b, 'symbol', optional: true
        option :c, 'string', optional: true
        option :d, 'time'
        option :f, optional: true
      end.new(1, 2, a: 3, b: :kek, d: Time.parse('2021-01-01'))

      expect(instance.x).to eq(1)
      expect(instance.y).to eq(2)
      expect(instance.b).to eq(:kek)
      expect(instance.c).to eq(nil)
      expect(instance.d).to eq(Time.parse('2021-01-01'))
      expect(instance.f).to eq(nil)
    end

    specify 'omitted :optional attributes uses the declared `:default` value' do
      instance = Class.new do
        include SmartCore::Initializer

        params :x, :y

        option :a, 'numeric'
        option :b, 'symbol', default: -> { :test_b }, optional: true
        option :c, 'string', default: -> { 'test_c' }, optional: true
        option :d, 'string', default: 'Test_D', optional: true
        option :e, 'time', default: -> { Time.parse('2022-01-01') }
        option :f, 'time', optional: true
      end.new(555, 666, a: 888)

      expect(instance.x).to eq(555)
      expect(instance.y).to eq(666)
      expect(instance.a).to eq(888)

      expect(instance.b).to eq(:test_b)
      expect(instance.c).to eq('test_c')
      expect(instance.d).to eq('Test_D')
      expect(instance.e).to eq(Time.parse('2022-01-01'))
      expect(instance.f).to eq(nil)
    end

    specify 'optional attributes without :default should not be finalized' do
      aggregate_failures 'without :default => without finalization' do
        instance = Class.new do
          include SmartCore::Initializer
          option :a, :numeric, optional: true, finalize: -> (val) { 123 }
        end.new
        expect(instance.a).to eq(nil)
      end

      aggregate_failures 'with :default => with finalization' do
        instance = Class.new do
          include SmartCore::Initializer
          option :a, :numeric, default: 3, optional: true, finalize: -> (val) { val * 2 }
        end.new
        expect(instance.a).to eq(6)
      end
    end

    specify 'expects boolean value' do
      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, optional: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: use OptionalArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, optional: Object.new
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: use OptionalArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, optional: true
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, optional: false
        end
      end.not_to raise_error
    end
  end

  describe ':default value' do
    specify 'dynamic value initializetion (usage of a proc/lambda)' do
      klass = Class.new do
        include SmartCore::Initializer

        option :a, default: proc { '123' }
        option :b, default: -> { Time.parse('2011-01-01') }
      end

      aggregate_failures 'pass only one attribute (first option)' do
        instance = klass.new(a: 10)
        expect(instance.a).to eq(10)
        expect(instance.b).to eq(Time.parse('2011-01-01'))
      end

      aggregate_failures 'pass only one attribute (second option)' do
        instance = klass.new(b: Time.parse('2088-01-01'))
        expect(instance.a).to eq('123')
        expect(instance.b).to eq(Time.parse('2088-01-01'))
      end

      aggregate_failures 'use defaults' do
        instance = klass.new
        expect(instance.a).to eq('123')
        expect(instance.b).to eq(Time.parse('2011-01-01'))
      end
    end

    specify 'duplicatable values (non-dynamic values should be duplicated during initialization' do
      some_static_value = 'test_123'

      klass = Class.new do
        include SmartCore::Initializer
        option :nickname, default: 'D@iVeR' # non-dynamic value (should be duplicated)
        option :age, default: -> { some_static_value } # dynamic value (should be returned "as-is")
      end

      first_instance = klass.new
      second_instance = klass.new

      # non-dynamic attributes are different
      expect(first_instance.nickname.object_id).not_to eq(second_instance.nickname.object_id)

      # dynamic attribute is static in our case - should have no difference
      expect(first_instance.age.object_id).to eq(second_instance.age.object_id)
    end

    specify 'default value should be type validated too' do
      klass = Class.new do
        include SmartCore::Initializer
        option :nickname, 'string', default: -> { 123 } # default value has invalid type
      end

      expect { klass.new }.to raise_error(SmartCore::Initializer::IncorrectTypeError)
    end
  end

  describe 'attribute type casting' do
    specify 'expects boolean' do
      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, :integer, cast: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: CastArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, :integer, cast: 'kek'
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: CastArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, :integer, cast: true
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          param :a, :integer, cast: false
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, :integer, cast: true
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, :integer, cast: false
        end
      end.not_to raise_error
    end

    specify 'attribte can be marked as type-castable (non-marked by default)' do
      klass = Class.new do
        include SmartCore::Initializer(auto_cast: true)

        param :a, 'integer', cast: true
        param :b, 'boolean', cast: true
        param :c, 'string'

        option :x, 'string', cast: true
        option :y, 'integer', cast: true
        option :z, 'array'
      end

      instance = klass.new('123', 456, 'test', x: :phone, y: '123.456', z: [])

      expect(instance.a).to eq(123)
      expect(instance.b).to eq(true)
      expect(instance.c).to eq('test')
      expect(instance.x).to eq('phone')
      expect(instance.y).to eq(123)
      expect(instance.z).to eq([])
    end

    specify 'automatic type casting' do
      klass = Class.new do
        include SmartCore::Initializer(auto_cast: true) # set the automatic type casting

        param :a, 'integer'
        option :b, 'string'
        param :c, 'boolean', cast: false # do not cast automaticaly
        option :d, 'string', cast: false # do not cast automaticaly
      end

      instance = klass.new('123', true, b: 456.789, d: '12000')
      expect(instance.a).to eq(123) # auto-casted from string to integer
      expect(instance.b).to eq('456.789') # auto-casted from float to string
      expect(instance.c).to eq(true)
      expect(instance.d).to eq('12000')
    end
  end

  describe 'mutable attributes' do
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
    specify 'expects boolean value' do
      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, mutable: 123
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: use MutableArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, mutable: Object.new
        end
      end.to raise_error(SmartCore::Initializer::ArgumentError) # TODO: use MutableArgumentError

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, mutable: true
        end
      end.not_to raise_error

      expect do
        Class.new do
          include SmartCore::Initializer
          option :a, mutable: false
        end
      end.not_to raise_error
    end
  end
end
