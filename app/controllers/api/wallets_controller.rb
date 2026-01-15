class Api::WalletsController< ApplicationController
    wrap_parameters false

  # POST /api/wallets
  def create
    
    @wallet=WalletService.create_wallet(
      user:current_user,
      currency_code:wallet_params[:currency_code],
      balance:wallet_params[:balance]
    )

    render :create,status: :created
  end


  # GET /api/wallets
  def index
    @wallets=Wallet.all;
    if wallet_params[:user_id]
      @wallets=@wallets.by_user(wallet_params[:user_id])
    end
    if wallet_params[:currency_code]
      @wallets=@wallets.by_currency(wallet_params[:currency_code])
    end  
    if wallet_params[:min_balance]|| wallet_params[:max_balance]
      @wallets=@wallets.by_balance(min_balance:wallet_params[:min_balance],max_balance:wallet_params[:max_balance]) 
    end
    @wallets=@wallets.page(wallet_params[:page]).per(wallet_params[:per_page] || 10)
    render :index,status: :ok

  end

  #GET /api/wallets/:id
  def show
    @wallet=Wallet.find_by!(id:wallet_params[:id])
    render :show,status: :ok
  end
  private

  def wallet_params
    params.permit(:id,:currency_code,:balance,:min_balance,:max_balance)
  end
end

