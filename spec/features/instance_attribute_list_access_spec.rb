# frozen_string_literal: true

RSpec.describe 'Instance attribute list access' do
  specify '#__params__ / #__options__ / #__attributes__' do
    instance = Class.new do
      include SmartCore::Initializer
      param :first_name, 'string', as: :first
      param :second_name, 'string', as: :last
      option :age, 'numeric', as: :years
      option :is_admin, 'boolean', default: true
    end.new('Rustam', 'Ibragimov', age: 27)

    aggregate_failures 'attribute access (result without aliases)' do
      expect(instance.__params__).to eq({
        first_name: 'Rustam',
        second_name: 'Ibragimov'
      })

      expect(instance.__options__).to eq({
        age: 27,
        is_admin: true
      })

      expect(instance.__attributes__).to eq({
        first_name: 'Rustam',
        second_name: 'Ibragimov',
        age: 27,
        is_admin: true
      })
    end
  end
end
