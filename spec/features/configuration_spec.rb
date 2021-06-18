# frozen_string_literal: true

RSpec.describe 'Initializer configuration' do
  describe 'type system' do
    specify 'default type system' do
      expect(SmartCore::Initializer::Configuration[:default_type_system]).to eq(:smart_types)
    end

    specify 'unsupported type system - fail' do
      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        default_type_system: :kek_pek
      })).to eq(false)
    end

    specify 'you can choose any supported type system' do
      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        default_type_system: :smart_types
      })).to eq(true)
    end
  end

  describe 'strict_options_count' do
    specify 'default value' do
      expect(SmartCore::Initializer::Configuration[:strict_options_count]).to be_truthy
    end

    specify 'unsupported value - fails' do
      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        strict_options_count: :kek_pek
      })).to eq(false)
    end
  end
end
