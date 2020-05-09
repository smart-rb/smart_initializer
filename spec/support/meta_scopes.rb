# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:example, :plugin) do |example|
    if SpecSupport.test_plugins?
      case example.metadata[:plugin]
      when :thy_types
        require 'thy'
        SmartCore::Initializer::Configuration.plugin(:thy_types)
      end
      example.call
    end
  end
end
