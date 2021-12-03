# frozen_string_literal: true

RSpec.describe 'SmartCore::Initializer integration' do
  describe 'configurable integration' do
    describe 'type_system config' do
      specify 'default config value (:smart_types)' do
        custom_klass = Class.new { include SmartCore::Initializer }
        expect(custom_klass.__initializer_settings__.type_system).to eq(:smart_types)
      end

      specify 'custom type_system definition' do
        custom_klass = Class.new { include SmartCore::Initializer(type_system: :smart_types) }
        expect(custom_klass.__initializer_settings__.type_system).to eq(:smart_types)
      end

      specify 'fails when the chosen type system is incorrect or unsupporeted' do
        expect do
          Class.new { include SmartCore::Initializer(type_system: :kek_pek) }
        end.to raise_error(SmartCore::Initializer::UnsupportedTypeSystemError)
      end
    end
  end

  describe 'strict_options config' do
    specify 'default config value (true)' do
      custom_klass = Class.new { include SmartCore::Initializer }
      expect(custom_klass.__initializer_settings__.strict_options).to eq(true)
    end

    specify 'custom strict_options definition' do
      # setup local config
      custom_klass = Class.new { include SmartCore::Initializer(strict_options: false) }
      expect(custom_klass.__initializer_settings__.strict_options).to eq(false)
      # check that global config has not been changed
      expect(SmartCore::Initializer::Configuration[:strict_options]).to eq(true)

      # setup another local config
      custom_klass = Class.new { include SmartCore::Initializer(strict_options: true) }
      expect(custom_klass.__initializer_settings__.strict_options).to eq(true)
      # check that global config has not been changed
      expect(SmartCore::Initializer::Configuration[:strict_options]).to eq(true)
    end

    specify 'fails when the strict_options value has incorrect type' do
      expect do
        Class.new { include SmartCore::Initializer(strict_options: 123) }
      end.to raise_error(SmartCore::Initializer::SettingArgumentError)
    end
  end

  describe 'auto_cast config' do
    specify 'default config value (true)' do
      custom_klass = Class.new { include SmartCore::Initializer }
      expect(custom_klass.__initializer_settings__.auto_cast).to eq(false)
    end

    specify 'custom auto_cast definition' do
      # setup local config
      custom_klass = Class.new { include SmartCore::Initializer(auto_cast: true) }
      expect(custom_klass.__initializer_settings__.auto_cast).to eq(true)
      # check that global config has not been changed
      expect(SmartCore::Initializer::Configuration[:auto_cast]).to eq(false)

      # setup another local config
      custom_klass = Class.new { include SmartCore::Initializer(auto_cast: false) }
      expect(custom_klass.__initializer_settings__.auto_cast).to eq(false)
      # check that global config has not been changed
      expect(SmartCore::Initializer::Configuration[:auto_cast]).to eq(false)
    end

    specify 'fails when the auto_cast value has incorrect type' do
      expect do
        Class.new { include SmartCore::Initializer(auto_cast: 123) }
      end.to raise_error(SmartCore::Initializer::SettingArgumentError)
    end
  end

  describe 'mixed configuration' do
    xspecify 'TODO'
  end
end
