
require File.expand_path('../../spec_helper', __FILE__)

describe Polylog::NullLogger do
  attr_reader :null_logger
  before(:all) { @null_logger = Polylog::NullLogger.new }

  it 'responds to `<<`' do
    expect(null_logger).to respond_to :<<
    expect(null_logger << 'foo').to be_nil
  end

  it 'responds to `close`' do
    expect(null_logger).to respond_to :close
    expect(null_logger.close).to be_nil
  end

  it 'responds to `debug?`' do
    expect(null_logger).to respond_to :debug?
    expect(null_logger.debug?).to be_false
  end

  it 'responds to `info?`' do
    expect(null_logger).to respond_to :info?
    expect(null_logger.info?).to be_false
  end

  it 'responds to `warn?`' do
    expect(null_logger).to respond_to :warn?
    expect(null_logger.warn?).to be_false
  end

  it 'responds to `error?`' do
    expect(null_logger).to respond_to :error?
    expect(null_logger.error?).to be_false
  end

  it 'responds to `fatal?`' do
    expect(null_logger).to respond_to :fatal?
    expect(null_logger.fatal?).to be_false
  end

  it 'responds to `add`' do
    expect(null_logger).to respond_to :add
    expect(null_logger.add 'foo').to be_false
  end

  it 'responds to `debug`' do
    expect(null_logger).to respond_to :debug
    expect(null_logger.debug 'foo').to be_false
  end

  it 'responds to `info`' do
    expect(null_logger).to respond_to :info
    expect(null_logger.info 'foo').to be_false
  end

  it 'responds to `warn`' do
    expect(null_logger).to respond_to :warn
    expect(null_logger.warn 'foo').to be_false
  end

  it 'responds to `error`' do
    expect(null_logger).to respond_to :error
    expect(null_logger.error 'foo').to be_false
  end

  it 'responds to `fatal`' do
    expect(null_logger).to respond_to :fatal
    expect(null_logger.fatal 'foo').to be_false
  end

  it 'responds to `unknown`' do
    expect(null_logger).to respond_to :unknown
    expect(null_logger.unknown 'foo').to be_false
  end

  it 'responds to `log`' do
    expect(null_logger).to respond_to :log
    expect(null_logger.log 'foo').to be_false
  end
end
