module Polylog

  # The purpose of the SoloProvider is to return a single instance for all
  # logger requests. You would use this provider to supply all parts of the
  # application with the exact same logger.
  #
  # The NullLogger uses the SoloProvider to register itself under the "null"
  # provider name.
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
