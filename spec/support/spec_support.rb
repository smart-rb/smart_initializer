# frozen_string_literal: true

module SpecSupport
  class << self
    def test_plugins?
      !!ENV['TEST_PLUGINS']
    end
  end
end
