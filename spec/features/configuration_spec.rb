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

  describe 'strict_options' do
    specify 'default value' do
      expect(SmartCore::Initializer::Configuration[:strict_options]).to eq(true)
    end

    specify 'unsupported value => fail' do
      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        strict_options: :kek_pek
      })).to eq(false)
    end

    specify 'you choose any supported config-switching' do
      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        strict_options: true
      })).to eq(true)

      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        strict_options: false
      })).to eq(true)
    end
  end

  describe 'auto_cast' do
    specify 'default value' do
      expect(SmartCore::Initializer::Configuration[:auto_cast]).to eq(false)
    end

    specify 'unsupported value => fail' do
      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        auto_cast: :kek_pek
      })).to eq(false)
    end

    specify 'you choose any supported config-switching' do
      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        auto_cast: true
      })).to eq(true)

      expect(SmartCore::Initializer::Configuration.config.valid_with?({
        auto_cast: false
      })).to eq(true)
    end
  end
end
