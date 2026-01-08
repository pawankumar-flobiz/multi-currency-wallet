class AuthorizationError < ApplicationError
  def initialize(message = "Forbidden", status: 403, code: "FORBIDDEN")
    super(message, status: status, code: code)
  end
end