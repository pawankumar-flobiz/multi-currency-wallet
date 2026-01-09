class ApplicationError < StandardError
  attr_reader :status, :code
  def initialize(message = "An application error has occurred.", status: 400, code: nil)
    super(message)
    @status = status
    @code = code
  end
end