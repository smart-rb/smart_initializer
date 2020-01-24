# frozen_string_literal: true

RSpec.describe 'Smoke Test' do
  specify do
    class User
      include SmartCore::Initializer
      # include SmartCore::Types::System(:T)
      # param :test, T::Value::Integer

      param :user_id, SmartCore::Types::Value::Integer, cast: true, default: 'test', privacy: :private
      option :password, SmartCore::Types::Value::Integer, cast: true, default: 'test', privacy: :private
      option :keka, finalize: (-> (value) { value.to_s })

      params :creds, :nickname
      options :metadata, :datameta
    end

    user = User.new(1, { admin: true }, '0exp', password: 'kek', metadata: {}, datameta: {}, keka: 123)
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
end
