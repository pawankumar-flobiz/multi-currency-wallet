# this simple check that everything  working or not
class HealthsController < ApplicationController

  def index
    user=current_user
    render json: { status: 'OK'}, status: :ok
  end

  def get_data_request
    Rails.logger.info "HealthController: Received get_data_request with params: #{params.inspect}"
    render json: { message: 'Data received successfully', data: health_params }, status: :ok  
  end

  private
  def health_params
     params.permit(:name,:email,:password)
  end
end