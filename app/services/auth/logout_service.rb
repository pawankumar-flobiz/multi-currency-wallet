module Auth
  class LogoutService
    def self.logout_user(token)
      raise AuthenticationError.new("Token is missing") if token.blank?
      # Jwt for validate token and delete the session
      Auth::JwtService.delete(token)
      true
    end
  end
end