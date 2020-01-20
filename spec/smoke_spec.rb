# frozen_string_literal: true

RSpec.describe 'Smoke Test' do
  specify do
    class User
      include SmartCore::Initializer
    end

    # class User
    #   include SmartCore::Initializer
    #   include SmartCore::Types::System(:T)

    #   param  :user_id,  T::String.nilable, cast: true, default: 'test'
    #   option :file,     T::String
    #   option :is_admin, T::Boolean.nilable, cast: true
    # end
  end
end
