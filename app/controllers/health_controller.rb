# this simple check that every working or not
class HealthController < ApplicationController
  include Authentication
  def index
    user=current_user
    render json: { status: 'OK'}, status: :ok
  end

  def dataFromPost
    Rails.logger.info "HealthController: Received dataFromPost with params: #{params.inspect}"
    render json: { message: 'Data received successfully', data: health_params }, status: :ok  
  end

  private
  def health_params
     params.permit(:name,:email,:password)
  end
end