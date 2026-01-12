module Api
  module Auth
    class SignupController < ApplicationController
      wrap_parameters false

      # POST  /api/auth/signup/request
      def request_otp
        user = ::Auth::SignupService.signup(signup_params)
        
        render json: { 
                    message: "OTP sent to email successfully",
                    data: {
                      user:{
                        name:user.name,
                        email:user.email,
                        create_at:user.create_at,
                        update_at:user.update_at
                      }
                    }
                  }, status: :ok
      end

      # POST /api/auth/signup/verify
      def verify_otp
    
        user = ::Auth::SignupService.verify_email(signup_params)
        render json:{
          message: "Email verified successfully",
          data:{
            user:{
                  name:user.name,
                  email:user.email,
                  created_at:user.created_at,
                  updated_at:user.updated_at
            }
          }
        }, status:200
      end

      private 
      def signup_params
        params.permit(:name, :email, :password,:otp)
      end
    end
  end
end