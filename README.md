## polylog

Decoupling the logging layer since 2012

### Description

Logging provides a simple mechanism for observing the state of a running
application, and most ruby gems and applications use some sort of logging.
This is great! Setting up a logging infrastructure across various gems and
applications is the not so great part.

In a Rails application it is assumed that all gems will use the `Rails.logger`
and that's the end of it. So as a gem developer you can just grab the Rails
logger and be done. The downside of that choice is your gem is now locked to
Rails and cannot be used elsewhere. Another option is to provide a
`setup( options = {} )` method (or something similar) and the application can
provide you with a logger. The downside of that choice is that applications
need to configure your gem and every other gem that adopts the same
convention.

A third option is to be clever and see if the Rails module exists when your
gem is loaded and then just grab the Rails logger. This makes testing
difficult and can lead to unintended side effects. Eschew clever code.

Polylog is an agreement between the gem developer and the application
developer on how logging is configured. For the gem developer, instead of
assuming the Rails environment or providing a `setup` method you ask Polylog
for a logger instance. For the application developer, instead of configuring
logging for multiple gems you configure Polylog with the logging
infrastructure you plan on using.

The gem developer no longer needs to worry what the application is going to
do. The logging for the gem does not need to be configured by the application.
Conversely, the application does not have to configure logging for every gem.
The application provides the logging infrastructure once to Polylog.

Let's see what this looks like in practice.

### Usage

The two primary use cases for Polylog are:

* obtaining a logger
* configuring the logging provider

Obtaining a logger is the domain of the gem developer (or supporting
application code). Configuring the logging provider is the domain of the
application.

#### Obtaining a Logger

Obtaining a logger is simple:

```ruby
Polylog.logger self
```

Passing `self` is optional but recommended. It provides context to Polylog and
allows object specific loggers to be returned (actually, they are class
specific). The application can configure different logger instances to be
returned depending upon the requesting class. This is useful if you want to
enable debugging for just one portion of the application.

In practice, you can create a module and include it where you want a `logger`
method to be available:

```ruby
module MyGem::Logger
  def logger
    Polylog.logger self
  end
end

class MyGem::SomeClass
  include MyGem::Logger
end
```

In this example each class in `MyGem` can obtain its own unique logger if
Polylog is configured to do so. But you can also develop your gem to use a
single logger instance, too.

```ruby
module MyGem::Logger
  def logger
    Polylog.logger 'MyGem'
  end
end
```

Instead of passing `self` the top level namespace of the gem is used. Anywhere
this logger module is included the returned logger will be the same.

#### Configuring the Logging Provider

Without any configuration Polylog with provide a null logger for all requests.
This logger implements all the methods of the Ruby `Logger` class, but all the
methods do nothing. Not very useful except for preventing exceptions.

So lets log everything to standard out (a useful start):

```ruby
provider = Polylog::SoloProvider.new(Logger.new(STDOUT))
Polylog.register_provider 'stdout', provider

Polylog.use_provider 'stdout'
```

Yikes! That looks pretty complicated. The three lines of code are the three
steps to configuring a logging provider.

The first line creates the provider we are going to use. The `SoloProvider`
provides exactly one logger. In the example it is providing a standard Ruby
`Logger` configured to log everything to `STDOUT`.

The second line registers the provider we created with Polylog. Multiple
providers can be registered but only one will be used. Each provider is
registered with a unique name. Logging frameworks like
[Log4r](https://github.com/colbygk/log4r), [Logging](https://github.com/twp/logging),
and [Scrolls](https://github.com/asenchi/scrolls) can register themselves with
Polylog. In this case, applications can skip the provider creation and just use
one that is already registered.

The third line tells Polylog to use the 'stdout' provider. All calls to
`Polylog.logger()` will lookup this provider and then call the `logger()`
method implemented by the provider. In this case, it is the solo-provider
which returns a STDOUT logger instance for all requests.

Lets register a few more providers:

```ruby
Polylog.register_provider 'stdout', Polylog::SoloProvider.new(Logger.new(STDOUT))
Polylog.register_provider 'stderr', Polylog::SoloProvider.new(Logger.new(STDERR))
Polylog.register_provider 'file',   Polylog::SoloProvider.new(Logger.new('app.log'))

Polylog.use_provider 'file'
```

Even though we have providers for logging to `STDOUT` and `STDERR`, we have
chosen to send all our logs to a file instead. It is easy enough to swap
providers now. Because we are using the solo-provider all log messages will
end up going to the same destination.

We can send log messages to multiple destinations by using a multi-provider.

```ruby
provider = Polylog::MultiProvider.new(Logger.new(STDOUT))
provider['MyClass'] = Logger.new('my_class.log')

Polylog.register_provider 'my_class', provider
Polylog.use_provider 'my_class'

Polylog.logger             # STDOUT logger
Polylog.logger(MyClass)    # 'my_class.log' logger
```

The multi-provider can return more than one logger instance. It is configured
to return a default logger for all requests. However, a different logger can
be returned based on the Class of the object passed to the `Polylog.logger()`
method. In the example we are passing in `MyClass` to get the specific logger
for that class; instances of `MyClass` would also return the same logger.

If you want to get more creative with your logging configuration, I highly
recommend checking out the [Logging](https://github.com/twp/logging)
framework. It is designed to provide unique loggers and logging destinations.

#### Integrating With Rails

It would be wonderful if Polylog were integrated directly with Rails. This
would require Rails to adopt the `Polylog.logger()` style of acquiring a
logger instance. However, until that time happens, Polylog needs to be
configured with a provider that returns the `Rails.logger` instance.

```ruby
Polylog.register_provider 'rails', Polylog::SoloProvider.new(Rails.logger)
Polylog.use_provider 'rails'
```

And that's pretty much it.

### Developing

Polylog makes use of Mr Bones to handle general project tasks such as running
tests, generating a gem file, interacting with **GitHub**, and publishing
to **rubygems.org**. A `script/bootstrap` script is provided to setup the
development environment:

```shell
script/bootstrap
```

After this is run, you can use `rake` normally to run tests. You can view all
the available rake tasks via `rake -T`.

```shell
rake -T
rake spec
```

Thank you for reading! Any contributions are greatly appreciated.
