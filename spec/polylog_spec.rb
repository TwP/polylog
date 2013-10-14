
require File.expand_path('../spec_helper', __FILE__)

describe Polylog do
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
end

