# frozen_string_literal: true

RSpec.describe 'Initializer configuration' do
  describe 'type system' do
    specify 'default type system' do
      expect(SmartCore::Initializer::Configuration[:default_type_system]).to eq(:smart_types)
    end

    specify 'unsupported type system - fail' do
      expect(
        SmartCore::Initializer::Configuration.config.valid_with?({
          default_type_system: :kek_pek
        })
      ).to eq(false)
    end
  end
end
