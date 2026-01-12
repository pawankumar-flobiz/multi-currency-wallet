module Authentication
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_request
  end

  private

  def authenticate_request
    token = extract_token
    unless Auth::JwtService.session_exists?(token)
      raise AuthenticationError.new("Session expired or logged out")
    end
    payload = Auth::JwtService.decode(token)
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