module GlobalErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from ApplicationError, with: :handle_application_error
  end

  private
  def handle_application_error(error)
    render json: { 
      error: {
        message: error.message,
        code: error.code
      }
    }, status: error.status
  end

  def handle_record_not_found(error)
    render json: { 
      error: {
        message:"Resource not found",
        code: "NOT_FOUND"
      }
    }, status: 404
  end

  def handle_record_invalid(error)
    render json: { 
      error: {
        message: error.record.errors.full_messages.join(", "),
        code: "RECORD_INVALID" 
      }
    }, status: 400
  end

  def handle_standard_error(error)
    Rails.logger.error "Error #{error.inspect}"
    render json: { 
      error: {
        message: "Internal server error",
        code: "INTERNAL_ERROR"
      }
    }, status: 500
  end
end
