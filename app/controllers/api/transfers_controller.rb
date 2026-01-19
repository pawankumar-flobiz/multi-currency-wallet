class Api::TransfersController < ApplicationController
  

  #create transation or send balance from one wallet to another wallet
  #POST api/transfers
  def create
    @transaction=TransferService.transfer_money(
      current_user,
      transfer_params[:receiver_id],
      transfer_params[:sender_currency_code],
      transfer_params[:receiver_currency_code],
      transfer_params[:amount]
    )
    @transaction = Transaction.includes(:user, :receiver).find(@transaction.id)
    render :create,status: :created
  end

  #list transfer or send balance from one wallet to another wallet
  #POST api/transfers
  def index
    @transactions= Transaction
                          .filter(current_user,transfer_params)
                          .includes(:user,:receiver)
                          .page(transfer_params[:page]|| 1).per(transfer_params[:per_page])
  end

  
  #Details of a particular transaction
  def show
    @transaction=Transaction
                    .all_transactions(current_user.id)
                    .includes(:user,:receiver)
                    .find_by!(id:transfer_params[:id])
  end

  private
  def transfer_params
    params.permit(
      :id,
      :amount,
      :currency_code,
      :sender_currency_code,
      :receiver_currency_code,
      :max_balance,:min_balance,
      :start_date,:end_date,
      :type,
      :receiver_id,
      :page,:per_page
      )
  end
end