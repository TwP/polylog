
module Polylog

  # The purpose of a MultiProvider is to provide a default logger instance
  # when requested. Other loggers can be provided by registering them with the
  # provider under the appropriate logger name. So when this name is passed to
  # the `logger` method the registered logger instance will be returned.
  #
  # The example below shows how to use the MultiProvider to send all log
  # messages from all instances of a single class to a log file instead of
  # STDOUT. You might want to do this when debugging the class; you can set
  # the logger level to debug and capture lots of text to a single location.
  #
  # Example
  #
  #     provider = Polylog::MultiProvider.new(Logger.new(STDOUT))
  #     provider['MyClass'] = Logger.new('my_class.log')
  #
  #     Polylog.register_provider 'example', provider
  #     Polylog.use_provider 'example'
  #
  #     logger          = Polylog.logger             # STDOUT logger
  #     my_class_logger = Polylog.logger(MyClass)    # 'my_class.log' logger
  #
  class MultiProvider

    # Create a new MultiProvider configured with the given logger as the
    # default logger. Other loggers can be added to the provider. These will
    # be returned by the provider (instead of the default logger) when their
    # name is passed to the `logger` method.
    #
    # logger - The default logger to return.
    def initialize( logger )
      @hash = Hash.new
      @default_logger = logger
    end

    # Accessor for getting and setting the default logger.
    attr_accessor :default_logger

    # Returns the named logger if it is present in the provider. If the named
    # logger is not present then the default logger is returned.
    #
    # name - The logger name as a String.
    def logger( name )
      return default_logger if name.nil?
      @hash.fetch(name, default_logger)
    end

    # Returns the logger or `nil` if the logger is not present.
    #
    # name - The logger name as a String.
    def []( name )
      @hash[name]
    end

    # Add a logger provider under the given name.
    #
    # name   - The logger name as a String.
    # logger - The logger.
    #
    # Returns the logger.
    def []=( name, logger )
      @hash[name] = logger
    end

    # Returns an Array with the names of the loggers present in the provider.
    def loggers
      @hash.keys
    end

    # Returns `true` if the logger is present in the provider.
    #
    # name - The logger name as a String.
    def logger?( name )
      @hash.key? name
    end

  end
end
