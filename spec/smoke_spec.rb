# frozen_string_literal: true

RSpec.describe 'Smoke Test' do
  specify do
    class User
      include SmartCore::Initializer

      param :user_id, :string, cast: true, default: 'test', privacy: :private
      option :password, :string, cast: true, default: 'test', privacy: :private
    end
  end
end
