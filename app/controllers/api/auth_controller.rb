class Api::AuthController <ApplicationController
  
  skip_before_action :authenticate_request,except:[:logout_user]
  
  wrap_parameters false

  #POST api/auth/check-email
  def check_email
    @user=User.active.find_by(email:auth_params[:email])
    
    if @user
      render :exists, status: :ok
    else
      render :not_exists, status: :not_found
    end

  end

  #POST api/auth/signup/request
  def signup_request
    @user=AuthService.signup_request(auth_params)
    render :signup_request,status: :created
  end

  # POST api/auth/signup/verify
  def email_verify
    @user=AuthService.email_verify(auth_params)
    render :email_verify,status: :ok
  end

  #POST api/auth/login/request
  def login_request
    user=AuthService.login_request(auth_params)
    render :login_request ,status: :ok
  end    

  #POST api/auth/login/verify
  def login_verify
    result=AuthService.login_verify(auth_params)
    @token = result[:token]
    @user  = result[:user]
    render :login_verify, status: :ok
  end 

  #POST api/auth/logout
  def logout_user
    AuthService.logout_user(current_user.id)
    render :logout_user, status: :ok
  end

  private 
  def auth_params
    params.permit(:name,:email,:password,:otp)
  end
end