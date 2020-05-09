# frozen_string_literal: true

RSpec.describe 'Initializer configuration' do
  describe 'type system' do
    specify 'default type system' do
      expect(SmartCore::Initializer::Configuration.config[:default_type_system]).to eq(:smart_types)
    end
  end
end
