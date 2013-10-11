
module Polylog
  extend self

  # Request a logger instance for the given object from the configured
  # provider.
  #
  # object - Any ruby object
  #
  # Returns a logger instance from the provider.
  def logger( object = nil )
    name = logger_name object
    provider.logger name
  end

  # Return the currently selected provider. If a provider has not yet been
  # specified, then the "null" provider will be used.
  #
  # Returns a logger provider.
  def provider
    use_provider('null') unless defined? @provider
    @provider
  end

  # Returns the list of available providers as an Array of Strings. These
  # names are used to select which provider to use.
  def providers
    @providers.keys
  end

  # Configure the logger provider that will be used by Polylog. The provider
  # must already be registered using the same `name`.
  #
  # name - The provider name as a String.
  #
  # Returns the logger provider.
  # Raises a Polylog::UnknownProvider exception.
  def use_provider( name )
    name = name.to_s
    raise Polylog::UnknownProvider, "unkonwn provider: #{name.inspect}" unless @providers.key? name

    @provider = @providers[name]
  end

  # Register a logger provider under the given name. The provider can be any
  # Ruby object that responds to the `logger` method and returns valid logger
  # instances. An exception is raised if the provider does not respond to the
  # `logger` method or the `logger` method does not have an arity of 1.
  #
  # name     - The provider name as a String.
  # provider - The provider object that responds to the `logger` method.
  #
  # Returns the logger provider.
  # Raises a Polylog::InvalidProvider exception.
  def register_provider( name, provider )
    @providers ||= Hash.new
    name = name.to_s

    unless provider.respond_to?(:logger)
      raise Polylog::InvalidProvider, "`logger` method not found for provider #{name.inspect}"
    end

    arity = provider.method(:logger).arity
    unless 1 == arity
      raise Polylog::InvalidProvider, "`logger` method arity must be 1; arity is #{arity} for provider #{name.inspect}"
    end

    @providers[name] = provider
  end

  # Internal: Given any ruby object, try to construct a sensible logger name
  # to use for looking up specific logger instances from a provider. For
  # nearly every object passed in this will be the class name of the instance.
  #
  # If you pass in `nil` or a String then the original object is return.
  # Symbols will be converted to Strings.
  #
  # The only objects we cannot generate a logger name for are anonymous
  # modules. For these we just return `nil`.
  #
  # object - Any ruby object
  #
  # Returns the logger name String or nil.
  def logger_name( object )
    case object
    when nil, String; object
    when Symbol; object.to_s
    when Module; logger_name_for_module(object)
    when Object; logger_name_for_module(object.class)
    end
  end

  # Internal: Generate logger names for classes, modules, singleton classes,
  # and anonymous modules. For all of these we use the class name or the
  # module name. For anonymous modules we return `nil`.
  #
  # mod - A Module or Class
  #
  # Returns the logger name String or nil.
  def logger_name_for_module( mod )
    return mod.name unless mod.name.nil? or mod.name.empty?

    # check if we have a metaclass (or eigenclass)
    if mod.ancestors.include? Class
      mod.inspect =~ %r/#<Class:([^#>]+)>/
      return $1
    end

    # see if we have a superclass
    if mod.respond_to? :superclass
      return logger_name_for_module(mod.superclass)
    end

    # we have an anonymous module
    return nil
  end

  LIBPATH = ::File.expand_path('../', __FILE__)
  PATH    = ::File.dirname(LIBPATH)

  # Returns the version String for the library.
  def version
    @version ||= File.read(path('version.txt')).strip
  end

  # Internal: Returns the library path for the module. If any arguments are
  # given, they will be joined to the end of the library path using
  # `File.join`.
  def libpath( *args )
    rv =  args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
    if block_given?
      begin
        $LOAD_PATH.unshift LIBPATH
        rv = yield
      ensure
        $LOAD_PATH.shift
      end
    end
    return rv
  end

  # Internal: Returns the path for the module. If any arguments are given,
  # they will be joined to the end of the path using `File.join`.
  def path( *args )
    rv = args.empty? ? PATH : ::File.join(PATH, args.flatten)
    if block_given?
      begin
        $LOAD_PATH.unshift PATH
        rv = yield
      ensure
        $LOAD_PATH.shift
      end
    end
    return rv
  end

end

require Polylog.libpath('polylog/errors')
require Polylog.libpath('polylog/solo_provider')
require Polylog.libpath('polylog/multi_provider')
require Polylog.libpath('polylog/null_logger')
