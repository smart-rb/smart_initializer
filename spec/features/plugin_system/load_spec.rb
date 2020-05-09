# frozen_string_literal: true

class SmartCore::Initializer::ALoadTest < SmartCore::Initializer::Plugins::Abstract
  def self.install!; end
end

class SmartCore::Initializer::BLoadTest < SmartCore::Initializer::Plugins::Abstract
  def self.install!; end
end

class SmartCore::Initializer::CLoadTest < SmartCore::Initializer::Plugins::Abstract
  def self.install!
    C_TEST_INTERCEPTOR.invoke
  end
end

class SmartCore::Initializer::DLoadTest < SmartCore::Initializer::Plugins::Abstract
  def self.install!
    D_TEST_INTERCEPTOR.invoke
  end
end

# rubocop:disable Layout/LineLength
SmartCore::Initializer::Configuration.register_plugin(:a_load_test, SmartCore::Initializer::ALoadTest)
SmartCore::Initializer::Configuration.register_plugin(:b_load_test, SmartCore::Initializer::BLoadTest)
SmartCore::Initializer::Configuration.register_plugin(:c_load_test, SmartCore::Initializer::CLoadTest)
SmartCore::Initializer::Configuration.register_plugin(:d_load_test, SmartCore::Initializer::DLoadTest)
# rubocop:enable Layout/LineLength

RSpec.describe 'SmartCore::Initializer::Plugins' do
  before do
    interceptor = Class.new { def invoke; end }
    stub_const('C_TEST_INTERCEPTOR', interceptor.new)
    stub_const('D_TEST_INTERCEPTOR', interceptor.new)
  end

  describe 'installation' do
    specify 'plugin loading interface' do
      expect(SmartCore::Initializer::ALoadTest).to receive(:load!).exactly(2).times
      expect(SmartCore::Initializer::BLoadTest).to receive(:load!).exactly(2).times

      SmartCore::Initializer::Configuration.plugin('a_load_test')
      SmartCore::Initializer::Configuration.plugin(:a_load_test)
      SmartCore::Initializer::Configuration.plugin('b_load_test')
      SmartCore::Initializer::Configuration.plugin(:b_load_test)
    end

    specify 'loaded plugins' do
      expect(SmartCore::Initializer::Configuration.loaded_plugins).not_to include(
        'a_load_test', 'b_load_test'
      )

      SmartCore::Initializer::Configuration.plugin('a_load_test')
      expect(SmartCore::Initializer::Configuration.loaded_plugins).to include('a_load_test')
      expect(SmartCore::Initializer::Configuration.loaded_plugins).not_to include('b_load_test')

      SmartCore::Initializer::Configuration.plugin('b_load_test')
      expect(SmartCore::Initializer::Configuration.loaded_plugins).to include(
        'a_load_test', 'b_load_test'
      )
    end
  end

  specify 'loading (loads only one time)' do
    expect(C_TEST_INTERCEPTOR).to receive(:invoke).exactly(1).time
    expect(D_TEST_INTERCEPTOR).to receive(:invoke).exactly(1).time

    SmartCore::Initializer::Configuration.plugin('c_load_test')
    SmartCore::Initializer::Configuration.plugin(:c_load_test)
    SmartCore::Initializer::Configuration.plugin('d_load_test')
    SmartCore::Initializer::Configuration.plugin(:d_load_test)
  end
end
