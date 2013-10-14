
require File.expand_path('../../spec_helper', __FILE__)

describe Polylog::SoloProvider do
  attr_reader :provider
  before(:all) { @provider = Polylog::SoloProvider.new 'Han Solo' }

  it 'always provides the same instance' do
    str = provider.logger nil

    expect(provider.logger 'foo').to equal str
    expect(provider.logger 'bar').to equal str
  end
end
