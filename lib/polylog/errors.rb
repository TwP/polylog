
module Polylog

  # Parent class for all Polylog errors.
  Error = Class.new StandardError

  # This is error is raised when an unknown provider is requested by the user.
  UnknownProvider = Class.new Error

end
