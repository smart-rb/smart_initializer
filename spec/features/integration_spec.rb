# frozen_string_literal: true

RSpec.describe 'SmartCore::Initializer integration' do
  describe 'configurable integration' do
    describe 'type_system config' do
      specify 'custom type-system definition' do
        custom_klass = Class.new { include SmartCore::Initializer(type_system: :smart_types) }
        expect(custom_klass.__initializer_settings__.type_system).to eq(:smart_types)
      end

      specify 'fails when the chosen type system is incorrect or unsupporeted' do
        expect do
          Class.new { include SmartCore::Initializer(type_system: :kek_pek) }
        end.to raise_error(SmartCore::Initializer::UnsupportedTypeSystemError)
      end

      specify ':smart_types used by default' do
        custom_klass = Class.new { include SmartCore::Initializer }
        expect(custom_klass.__initializer_settings__.type_system).to eq(:smart_types)
      end
    end
  end

  describe 'strict_options config' do
    xspecify 'TODO'
  end

  describe 'auto_cast config' do
    xspecify 'TODO'
  end

  describe 'mixed configuration' do
    xspecify 'TODO'
  end
end
