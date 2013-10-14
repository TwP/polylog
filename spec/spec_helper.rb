
require File.expand_path('../../lib/polylog', __FILE__)

RSpec.configure do |config|
  config.before(:all) { Polylog.reset! }

  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

module Polylog
  # Only used for testing. This resets the Polylog providers configuration to
  # its uninitialized state.
  def reset!
    remove_instance_variable :@provider  if defined? @provider

    @providers.keys.each do |key|
      next if key == 'null'
      @providers.delete key
    end

    self
  end
end

