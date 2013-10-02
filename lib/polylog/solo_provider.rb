module Polylog

  # The purpose of the SoloProvider is to return a single instance for all
  # logger requests. You would use this provider to supply all parts of the
  # application with the exact same logger.
  #
  # The NullLogger uses the SoloProvider to register itself under the "null"
  # provider name.
  #
  # Examples
  #
  #     Polylog.register_provider 'stdout', Polylog::SoloProvider.new(Logger.new(STDOUT))
  #     Polylog.register_provider 'stderr', Polylog::SoloProvider.new(Logger.new(STDERR))
  #     Polylog.register_provider 'file',   Polylog::SoloProvider.new(Logger.new('app.log'))
  #
  #     Polylog.use_provider 'stderr'
  #     logger = Polylog.logger     # returns a STDERR logger
  #
  #     Polylog.use_provider 'file'
  #     logger = Polylog.logger     # returns an 'app.log' file logger
  #
  class SoloProvider

    # Constructs a new SoloProvider that will provide the same instance for
    # each request for a logger.
    #
    # logger - The logger instance that will be provided.
    def initialize( logger )
      @logger = logger
    end

    # Returns the same logger instance for all requests. The `name` is not
    # used by this this method.
    #
    # name - The logger name as a String
    def logger( name )
      @logger
    end

  end
end
