class DuplicateRequestError < ApplicationError
  def initialize(message = "Duplicate request detected.", status: 409, code: "DUPLICATE_REQUEST")
    super(message, status: status, code: code)
  end
end