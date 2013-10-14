
require File.expand_path('../spec_helper', __FILE__)

describe Polylog do

  it 'provides a canonical version string' do
    expect(Polylog.version).to match %r/^\d+\.\d+\.\d+$/
  end

  context 'without any configuration' do
    it 'provides a null logger' do
      expect(Polylog.logger).to be_an_instance_of Polylog::NullLogger
    end

    it 'provides the smae null logger for all requests' do
      null_logger = Polylog.logger

      expect(Polylog.logger 'foo').to equal null_logger
      expect(Polylog.logger 'bar').to equal null_logger
    end

    it 'only has the null provider registered' do
      expect(Polylog.providers).to eq %w[null]
    end
  end

  context 'when registering a provider' do
    it 'raises an error for providers that have no `logger` method' do
      expect {
        Polylog.register_provider('nope', Object.new)
      }.to raise_error(Polylog::InvalidProvider, /method not found for provider/)
    end

    it 'raises an error when the `logger` method has the wrong airty' do
      provider = Object.new
      class << provider
        def logger() nil; end
      end

      expect {
        Polylog.register_provider('nope', provider)
      }.to raise_error(Polylog::InvalidProvider, /method arity must be 1/)
    end

    it 'adds the provider to the registry' do
      expect(Polylog.providers).not_to include('test1')

      provider = Polylog::SoloProvider.new(:test1)
      Polylog.register_provider 'test1', provider

      expect(Polylog.providers).to include('test1')
    end

    it 'overwrites existing providers' do
      provider = Polylog::SoloProvider.new(:test2)
      Polylog.register_provider 'test2', provider
      expect(Polylog.providers).to include('test2')
      Polylog.use_provider 'test2'

      provider = Polylog::SoloProvider.new(:overwrite)
      Polylog.register_provider 'test2', provider

      expect(Polylog.logger).to equal :test2
      Polylog.use_provider 'test2'
      expect(Polylog.logger).to equal :overwrite
    end
  end

  context 'when selecting a provider to use' do
    it 'raises an error for unknown providers' do
      expect {
        Polylog.use_provider 'foo'
      }.to raise_error(Polylog::UnknownProvider, 'unknown provider: "foo"')
    end

    it 'can use a registered provider' do
      provider = Polylog::SoloProvider.new(:test3)
      Polylog.register_provider 'test3', provider

      expect(Polylog.providers).to include('test3')

      Polylog.use_provider 'test3'
      expect(Polylog.logger).to equal :test3
    end
  end

  context 'when generating logger names' do
    it 'uses nil as the default' do
      expect(Polylog.logger_name nil).to be_nil
    end

    it 'uses String names as is' do
      expect(Polylog.logger_name 'foo').to eql 'foo'
    end

    it 'converts Symbols to Strings' do
      expect(Polylog.logger_name :foo).to eql 'foo'
    end

    it 'uses Module names' do
      expect(Polylog.logger_name Enumerable).to eql 'Enumerable'
    end

    it 'uses Class names for instances' do
      expect(Polylog.logger_name Object).to eql 'Object'
      expect(Polylog.logger_name Object.new).to eql 'Object'
      expect(Polylog.logger_name []).to eql 'Array'
    end

    it 'uses the orignal Class name for singletons (eigenclasses)' do
      ary = []
      eigen = class << ary; self; end

      expect(Polylog.logger_name eigen).to eql 'Array'
    end

    it 'gives up when confronted with an anonymous module' do
      m = Module.new { def foo() nil end }
      expect(Polylog.logger_name m).to be_nil
    end
  end

end

