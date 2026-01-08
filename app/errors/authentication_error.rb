class AuthenticationError < ApplicationError
  def initialize(message = "Unauthorized", status: 401, code: "AUTH_ERROR")
    super(message, status: status, code: code)
  end
end