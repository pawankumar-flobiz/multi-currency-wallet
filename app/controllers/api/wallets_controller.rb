module Api
  class WalletsController< ApplicationController
    include Authentication
    

    # POST /api/wallets
    def create
      #call walletService to create wallet
      wallet=::WalletService.create_wallet(
        user:current_user,
        currency_code:params[:currency_code]
      )

      render json:{
        message:"Wallet created successfully!",
        data:{
          wallet:wallet_response(wallet)
        }
      },status: :created
    end


    # GET /api/wallets
    def index
      wallets=current_user.wallets;
      render json: {
        message:"Wallets get successfully!",
        data:{
          wallets: wallets.map do |wallet|
          wallet_response(wallet)
          end
        }
      },status: :ok

    end

    #GET /api/wallets/:id
    def show
      wallet=current_user.wallets.find(params[:id])
      render json:{
        message:"Wallet get successfully!",
        data:{
          wallet:wallet_response(wallet)
        }
      },status: :ok
    end
    private 

    def wallet_response(wallet)
      {
        id: wallet.id,
        currency: wallet.currency_code,
        balance: wallet.balance
      }
    end
  end
end
