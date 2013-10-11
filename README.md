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
Polylog.register_provider('stdout', provider)

Polylog.use_provider 'stdout'
```

Yikes! That looks pretty complicated. 


----

**Random notes below this point - still a work in progress.**

----

Including a method for logging events and actions 

In Ruby there is no agreed upon way to obtain a `Logger` instance. Each
library developer is left to their own devices. The two most often used
strategies are to either provide an accessor method or to assume the Rails
environment is present and use the `Rails.logger`.

The disadvantage of the latter approach is that the library is now constrained
to operate in just the Rails environment. This is fine for some cases, but 

logger accessor .
a problem 
Generating log messages is a good software practice, but where to send those
messages? If you're writing a gem it makes sense to use the Ruby `Logger`
class and write to standard out for testing.

Each gem or library that a user includes in an application will require some
sort of logging configuration - at least for those that have implemented
logging.

which logging implementation to use at runtime. 


The goal of the Ruby Abstract Logging Layer is to enable gems and libraries to
generate log messages without specifying a specific type of **Logger** or
logging destination. The choice of the **Logger** and logging destination is
left to the application. This enables developers to include logging without
forcing other users into a specific logging implementation.

This flexibility is incredibly useful when targeting both Rails and non-Rails
applications.

The caveat of this goal is that "everyone" needs to agree to use a single
source when requesting a **Logger** instance. The single source is an [abstract
factory](FIXME: needs a URL). Developers request a **Logger** from the
abstract factory, and applications specify the actual provider of those
**Logger** instances being returned. The developer is free then to include
logging in their code knowing that the application is not locked into their
choice of **Logger**. Conversely, the application can choose the most
appropriate **Logger** implementation for the task at hand: logging to stdout,
logging to a file, or sending messages to rsyslog.

In the case of Rails applications, the Rails logger is used. However, gems
which were once constrained to explicitly constrained to using the Rails
logger can now be used in other contexts. All in all this goal allows for
broader reuse cases and greater sharing of the best tools inside the Ruby
community.

Design
------

Factory
- Rall.logger(obj)  #=> Logger

Provider
- Register a provider
  * configures the provider
  * return instances when asked

Mixin
- Provides a `logger` method that retrieves a Rall.logger

Requirements
------------

* FIXME (list of requirements)

Install
-------

    gem install polylog

* FIXME (sudo gem install, anything else)

Developing
----------

The **rall** gem makes use of Mr Bones to handle general project tasks such as
running tests, generating a gem file, interacting with **GitHub**, and publishing
to **rubygem.org**. You will need to have a recent version of the **bones**
gem installed.

    gem install bones

The required gem dependencies can be installed via the rake task:

    rake gem:install_dependencies

Mr Bones provides a number of other useful rake tasks. They can be listed via
```rake -T```. Thanks for reading; any contributions you are willing to make
are greatly appreciated.

Author
------

Original author: Tim Pease

License
-------

(The MIT License)

Copyright (c) 2012 by Tim Pease

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
