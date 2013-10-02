
module Polylog

  # Parent class for all Polylog errors.
  Error = Class.new StandardError

  # This is error is raised when an unknown provider is requested by the user.
  UnknownProvider = Class.new Error

  # This is error is raised when a provider is registered and it does not
  # respond to the `logger` method or the `logger` method has an arity other
  # than 1.
  InvalidProvider = Class.new Error

end
