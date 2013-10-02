
module Polylog

  # This is a no-op logger that implements the principal methods from the
  # standard Ruby logger. All methods do nothing and return either `false`
  # or `nil`.
  class NullLogger
    def <<(msg) nil end
    def close() nil end

    def debug?() false end
    alias :info?  :debug?
    alias :warn?  :debug?
    alias :error? :debug?
    alias :fatal? :debug?

    def add(*args) false end
    alias :debug   :add
    alias :info    :add
    alias :warn    :add
    alias :error   :add
    alias :fatal   :add
    alias :unknown :add
    alias :log     :add
  end

  register_provider('null', SoloProvider.new(NullLogger.new))
end
