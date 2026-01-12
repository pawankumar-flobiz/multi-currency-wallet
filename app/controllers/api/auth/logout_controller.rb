module Api
  module Auth
    class LogoutController < ApplicationController
      include Authentication
      
      # POST /api/auth/logout
      def logout_user
        token = extract_token
        ::Auth::LogoutService.logout_user(token)
        render json: { message: "Successfully logged out" }, status: :ok
      end
    end
  end
end
