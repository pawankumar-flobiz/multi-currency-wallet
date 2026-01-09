class ValidationError < ApplicationError
  def initialize(message = "Validation failed", status: 400, code: "VALIDATION_ERROR")
    super(message, status: status, code: code)
  end
end