class Api::AuthController <ApplicationController
  
  skip_before_action :authenticate_request,except:[:logout_user,:index,:current_login_user]
  

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
    render :signup_request,status: :created # not remove beacuse of status code if remove then status code send by 200
  end

  # POST api/auth/signup/verify
  def email_verify
    @user=AuthService.email_verify(auth_params)
  end

  #POST api/auth/login/request
  def login_request
    @user=AuthService.login_request(auth_params)
  end    

  #POST api/auth/login/verify
  def login_verify
    result=AuthService.login_verify(auth_params)
    @token = result[:token]
    @user  = result[:user]
  end 

  #POST api/auth/logout
  def logout_user
    AuthService.logout_user(current_user.id)
  end

  #GET api/auth
  def index
    @users = User.active

    if auth_params[:name].present?
      @users = @users.by_name(auth_params[:name])
    end

    if auth_params[:email].present?
      @users = @users.by_email(auth_params[:email].downcase)
    end

    @users = @users.page(auth_params[:page]).per(auth_params[:per_page] || 10)

    render :index, status: :ok
  end

  #GET api/auth/:id
  def current_login_user
    @user= current_user
    render :show ,status: :ok
  end

  private 

  def auth_params
    params.permit(
      :name,
      :email,
      :password,
      :otp,
      :id,
      :page,
      :per_page
    )
  end
end