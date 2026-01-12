module Auth
  class SignupService
    OTP_EXPIRY_TIME = Settings.otp.expiry.to_i #in minutes
    
    # Sign up user and send OTP for email verification
    
    def self.signup(params)

      raise ValidationError.new("Email is required") if params[:email].blank?
      raise ValidationError.new("Password is required") if params[:password].blank?

      email = params[:email].downcase.strip
      user = nil

      ActiveRecord::Base.transaction do

        user = User.create!(
          name: params[:name],
          email: email,
          password: params[:password]
        )
        user.update!(otp_sent_at: Time.current)
      end

      # Send OTP by email
      OtpMailer.with(user:user).send_otp.deliver_later
      user
    end


    # Verify email using OTP
    def self.verify_email(params)

      raise ValidationError.new("Email requiered") if params[:email].blank?
      raise ValidationError.new("OTP is required!") if params[:otp].blank?
      email=params[:email].downcase.strip
      user = User.find_by!(email:email, deleted_at:nil)

      raise ValidationError.new("Email alredy verified") if user.email_verified?
      raise ValidationError.new("Invalid email or OTP expired") if otp_expired?(user)
      raise ValidationError.new("Invalid OTP") unless user.authenticate_otp(params[:otp],draft:OTP_EXPIRY_TIME*60)

      user.update!(
        email_verified_at: Time.current,
        otp_sent_at:nil
      )

      user
    end

    private

    # Check if OTP is expired
    def self.otp_expired?(user)
      user.otp_sent_at.nil? || user.otp_sent_at < OTP_EXPIRY_TIME.minutes.ago
    end

  end
end