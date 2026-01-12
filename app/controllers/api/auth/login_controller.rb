module Api
  module Auth
    class LoginController < ApplicationController

      wrap_parameters false
      # POST /api/auth/login/request
      def request_otp
        params = login_params
        user = ::Auth::LoginService.login(params)
        render json: { 
          message: "OTP sent to email successfully",
          data: { 
            user:{
                  name:user.name,
                  email:user.email,
                  created_at:user.created_at,
                  updated_at:user.updated_at
            }} 
          }, status: :ok
      end

      # POST /api/auth/login/verify
      def verify_otp
        params = login_params
        result = ::Auth::LoginService.verify(params)
         
        render json: { 
          message: "Login successful",
          token: result[:token],
          data: { 
            user:{
              name:result[:user].name,
              email:result[:user].email,
              created_at:result[:user].created_at,
              updated_at:result[:user].updated_at

            } 
          }
          }, status: :ok
      end

      private 
      def login_params
        params.permit(:email, :password, :otp)
      end
    end
  end
end
