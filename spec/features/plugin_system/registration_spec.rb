# frozen_string_literal: true

# rubocop:disable Layout/LineLength
SmartCore::Initializer::Plugins::ExistenceTest = Class.new(SmartCore::Initializer::Plugins::Abstract)
SmartCore::Initializer.register_plugin(:existence_test, SmartCore::Initializer::Plugins::ExistenceTest)
# rubocop:enable Layout/LineLength

SmartCore::Initializer::Plugins::ARegTest = Class.new(SmartCore::Initializer::Plugins::Abstract)
SmartCore::Initializer::Plugins::BRegTest = Class.new(SmartCore::Initializer::Plugins::Abstract)

RSpec.describe 'SmartCore::Initializer::Plugins' do
  specify 'plugin registration' do
    expect(SmartCore::Initializer::Plugins.names).not_to include('a_reg_test', 'b_reg_test')
    expect(SmartCore::Initializer.plugins).not_to        include('a_reg_test', 'b_reg_test')

    SmartCore::Initializer.register_plugin(:a_reg_test, SmartCore::Initializer::Plugins::ARegTest)

    expect(SmartCore::Initializer::Plugins.names).to include('a_reg_test')
    expect(SmartCore::Initializer.plugins).to include('a_reg_test')
    expect(SmartCore::Initializer::Plugins.names).not_to include('b_reg_test')
    expect(SmartCore::Initializer.plugins).not_to include('b_reg_test')

    SmartCore::Initializer.register_plugin(:b_reg_test, SmartCore::Initializer::Plugins::BRegTest)

    expect(SmartCore::Initializer::Plugins.names).to include('a_reg_test', 'b_reg_test')
    expect(SmartCore::Initializer.plugins).to include('a_reg_test', 'b_reg_test')
  end

  describe 'incompatability-related failures' do
    specify 'plugin registration which name is in conflict with already registered plugin' do
      expect do
        SmartCore::Initializer::Plugins.register_plugin(:existence_test, Object)
      end.to raise_error(SmartCore::Initializer::AlreadyRegisteredPluginError)
      expect do
        SmartCore::Initializer.register_plugin(:existence_test, Object)
      end.to raise_error(SmartCore::Initializer::AlreadyRegisteredPluginError)
    end

    specify 'loading of unregistered plugin' do
      expect do
        SmartCore::Initializer::Plugins.load(:kek_test_plugin)
      end.to raise_error(SmartCore::Initializer::UnregisteredPluginError)
      expect do
        SmartCore::Initializer.plugin(:kek_test_plugin)
      end.to raise_error(SmartCore::Initializer::UnregisteredPluginError)
      expect do
        SmartCore::Initializer.load(:kek_test_plugin)
      end.to raise_error(SmartCore::Initializer::UnregisteredPluginError)
      expect do
        SmartCore::Initializer.enable(:kek_test_plugin)
      end.to raise_error(SmartCore::Initializer::UnregisteredPluginError)
    end
  end
end
