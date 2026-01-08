class InsufficientBalanceError < ApplicationError
  def initialize(message = "Insufficient wallet balance to complete the transaction.", status: 402, code: "INSUFFICIENT_BALANCE")
    super(message, status: status, code: code)
  end
end