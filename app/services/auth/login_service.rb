module Auth
  class LoginService

    OTP_EXPIRY_TIME = Settings.otp.expiry.to_i #in minutes
    
    def self.login(params)
      raise ValidationError.new("Email is required") if params[:email].blank?
      raise ValidationError.new("Password is required") if params[:password].blank?
      email=params[:email].downcase.strip
      user=User.active.find_by!(email: email)

      raise ValidationError.new("Invalid credentials") unless user.authenticate(params[:password])
      raise ValidationError.new("Email not verified") unless user.email_verified?

      
      user.update!(otp_sent_at: Time.current)

      #Send OTP via email Using Mailer
      OtpMailer.with(user:user).send_otp.deliver_later
      user
    end

    def self.verify(params)
      raise ValidationError.new("Email is required") if params[:email].blank?
      raise ValidationError.new("OTP is required") if params[:otp].blank?
      email=params[:email].downcase.strip
      user = User.active.find_by!(email:email)

      raise ValidationError.new("OTP is expired") if otp_expired?(user)
      raise ValidationError.new("Invalid OTP") unless user.authenticate_otp(params[:otp],drift:OTP_EXPIRY_TIME*60)

      #clear OTP timestamp after successful login
      user.update!(otp_sent_at: nil)

      #Generate JWT token and store in Redis for session management
      token= JwtService.encode({user_id:user.id, email:user.email})

      {
        user: user,
        token: token
      }
    end
    private
    def self.otp_expired?(user)
      user.otp_sent_at.nil? || user.otp_sent_at < OTP_EXPIRY_TIME.minutes.ago
    end
  end
end