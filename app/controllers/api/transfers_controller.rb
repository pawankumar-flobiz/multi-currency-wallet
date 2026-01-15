class Api::TransfersController < ApplicationController
  wrap_parameters false

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

    render :create,status: :created
  end

  #list transfer or send balance from one wallet to another wallet
  #POST api/transfers
  def index
    @transactions=Transaction.all
    if transfer_params[:sender_id].present?
      @transactions=@transactions.by_sender(transfer_params[:sender_id])
    end

    if transfer_params[:receiver_id].present?
      @transactions=@transactions.by_receiver(transfer_params[:receiver_id])
    end

    if transfer_params[:min_balance].present? || transfer_params[:max_balance].present?
      @transactions=@transactions.by_balance(transfer_params[:min_balance],transfer_params[:max_balance])
    end

    if transfer_params[:start_date].present? || transfer_params[:end_date].present?
      @transactions=@transaction.by_date(transfer_params[:start_date],transfer_params[:end_date])
    end
    if transfer_params[:sender_currency_code].present?
      @transactions=@transactions.by_sender_currency(transfer_params[:sender_currency_code])
    end
    if transfer_params[:receiver_currency_code].present?
      @transactions=@transactions.by_receiver_currency(transfer_params[:receiver_currency_code])
    end
    @transactions=@transactions.page(transfer_params[:page]|| 1).per(transfer_params[:per_page])
    render :index, status: :ok
  end

  #Details of a particular transaction
  def show
    @transaction=Transaction.find_by!(id:transfer_params[:id])
    render :show, status: :ok
  end

  private
  def transfer_params
    params.permit(
      :id,:receiver_id,:amount,:currency_code,
      :sender_currency_code,:receiver_currency_code,
      :sender_id,:max_balance,:min_balance,:start_date,:end_date)
  end
end