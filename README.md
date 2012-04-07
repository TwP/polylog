rall
====

Ruby Abstract Logging Layer

Description
-----------

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

    gem install rall

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
