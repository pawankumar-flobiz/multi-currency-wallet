class AuthService
  OTP_EXPIRY_TIME = Settings.otp.expiry.to_i #in minutes

  # sign up user and send OTP for email verification
  def self.signup_request(params)

    validate_email(params)
    validate_name(params)
    validate_password(params)

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

    #Send otp  by email
    OtpMailerWorker.perform_async(user.id)
    user
  end

  # verify the email for created user
  def self.email_verify(params)
    validate_email(params)
    validate_otp(params)

    email=params[:email].downcase.strip
    user = User.find_by!(email:email, deleted_at:nil)
    
    raise ValidationError.new("Email alredy verified") if user.email_verified?
    
    verify_otp(user,params[:otp])

    user.update!(
      email_verified_at:Time.current,
      otp_sent_at:nil
    )
    user
  end

  # login request for user
  def self.login_request(params)
    validate_email(params)
    validate_password(params)
    email=params[:email].downcase
    user=User.active.find_by!(email:email)
    
    raise ValidationError.new("Invalid credentials!") unless user.authenticate(params[:password])
    raise ValidationError.new("Email is not verified!") unless user.email_verified?

    user.update!(otp_sent_at: Time.current)

    #Send OTP via email Using MailerWorker
    OtpMailerWorker.perform_async(user.id)
    user
  end

  def self.login_verify(params)
    validate_email(params)
    validate_otp(params)
    email=params[:email].downcase
    user=User.active.find_by!(email:email)

    verify_otp(user,params[:otp])

    #clear the timestamp
    user.update!(otp_sent_at: nil)
    #Generate JWT token and store in Redis for session management
    token= JwtService.encode({user_id:user.id, email:user.email})

    {
      user: user,
      token: token
    }
  end

  def self.logout_user(user_id)
    result=JwtService.delete(user_id)
    raise ApplicationError.new("An application error occure please try again",status: 500,code:"APPLICATION_ERROR") if result==0
  end
 
  private

  # verify the otp is correct or not
  def self.verify_otp(user,otp)
    raise ValidationError.new("Invalid opt or expired otp")  unless user.authenticate_otp(otp,drift:60)
  end

  
  def self.validate_name(params)
    raise ValidationError.new("Name is required!") if params[:name].blank?
  end

  def self.validate_otp(params)
    raise ValidationError.new("OTP is required!") if params[:otp].blank?
  end

  def self.validate_email(params)
    raise ValidationError.new("Email is required!") if params[:email].blank?
  end

  def self.validate_password(params)
    raise ValidationError.new("Password is required!") if params[:password].blank?
    raise ValidationError.new("Password length must be atlest 6 character!") if params[:password].length<6
  end


end