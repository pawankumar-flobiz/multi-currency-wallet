module Authentication
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_request
    helper_method :current_user
  end

  private

  def authenticate_request
    token = extract_token
    payload = JwtService.decode(token)
    unless JwtService.session_exists?(payload["user_id"])
      raise AuthenticationError.new("Session expired or logged out")
    end
   
    @current_user = User.active.find_by!(id: payload["user_id"])
  rescue ActiveRecord::RecordNotFound
    raise AuthenticationError.new("Invalid token or user not found")
  end

  def current_user
    @current_user
  end
  
  def extract_token
    header=request.headers['Authorization']
    raise AuthenticationError.new("Authorization header missing") if header.blank?
    
    token=header.split(' ').last
    raise AuthenticationError.new("Invalid authorization format") if  token.blank?
    token
  end
end