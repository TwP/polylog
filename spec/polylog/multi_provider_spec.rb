
require File.expand_path('../../spec_helper', __FILE__)

describe Polylog::SoloProvider do
  attr_reader :provider

  context 'with only a default logger' do
    before(:all) { @provider = Polylog::MultiProvider.new 'Multipass' }

    it 'provides the same default logger' do
      default = provider.default_logger

      expect(provider.logger 'foo').to equal default
      expect(provider.logger 'bar').to equal default
    end
  end

  context 'when configured with multiple loggers' do
    before(:all) do
      @provider = Polylog::MultiProvider.new 'Multipass'
      @provider['foo'] = 'FooLogger'
      @provider['bar'] = 'BarLogger'
    end

    it 'provides loggers based on name' do
      expect(provider.logger 'foo').to equal provider['foo']
      expect(provider.logger 'bar').to equal provider['bar']
      expect(provider.logger 'baz').to equal provider.default_logger
    end

    it 'returns the list of available loggers' do
      expect(provider.loggers).to match_array %w[foo bar]
    end

    it 'determines if a logger is present' do
      expect(provider.logger? 'foo').to be_true
      expect(provider.logger? 'bar').to be_true
      expect(provider.logger? 'baz').to be_false
    end
  end
end
