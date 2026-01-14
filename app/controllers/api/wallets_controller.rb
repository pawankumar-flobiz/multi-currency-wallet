class Api::WalletsController< ApplicationController
    
  # POST /api/wallets
  def create
    
    @wallet=WalletService.create_wallet(
      user:current_user,
      currency_code:wallet_params[:currency_code],
      balance:wallet_params[:balance]
    )

    render :create,status: :created # not removed because status code always 200
  end

  # GET /api/wallets
  def index
    @wallets=current_user.wallets
                         .filtered(wallet_params)
                         .page(wallet_params[:page] || 1)
                         .per(wallet_params[:per_page]|| 5)

  end

  #GET /api/wallets/:id
  def show
    @wallet=current_user.wallets.find_by!(id:wallet_params[:id])
  end

  private

  def wallet_params
    params.permit(
      :id,
      :currency_code,
      :balance,
      :min_balance,
      :max_balance,
      :page,
      :per_page
    )
  end
end

