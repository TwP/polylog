
module Polylog

  module NullProvider
    extend self

    #
    #
    # name - The logger name as a String
    #
    # Returns the same NullLogger instance for all requests.
    def logger( name )
      @logger ||= NullLogger.new
    end

    class NullLogger
      def debug?() false end
      alias :info? :debug?
      alias :warn? :debug?
      alias :error? :debug?
      alias :fatal? :debug?

      def debug(*args) false end
      alias :info :debug
      alias :warn :debug
      alias :error :debug
      alias :fatal :debug
    end

  end
end

Polylog.register_provider 'null', Polylog::NullProvider

