class Transaction < ApplicationRecord
  belongs_to :user               # Sender
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
  
  # Money leaving wallet
  belongs_to :sender_wallet,
             class_name: 'Wallet',
             foreign_key: :sender_wallet_id

  # Money entering wallet
  belongs_to :receiver_wallet,
             class_name: 'Wallet',
             foreign_key: :receiver_wallet_id

  enum from_currency: CURRENCY_ENUM, _prefix: true
  enum to_currency:   CURRENCY_ENUM, _prefix: true

  validates :amount, numericality: { greater_than: 0 }
  validates :exchange_rate, numericality: { greater_than: 0 }
  validates :fee, numericality: { greater_than_or_equal_to: 0 }

  scope :all_transactions, ->(user_id){
    where("user_id = :id OR receiver_id = :id", id: user_id)
  }
  
  scope :by_balance, ->(min_balance: nil, max_balance: nil) {
    scope = all
    scope = scope.where("total_debit >= ?", min_balance) if min_balance.present?
    scope = scope.where("total_debit <= ?", max_balance) if max_balance.present?
    scope
  }

  scope :deposit,->(user_id){where(user_id:user_id)}

  scope :withdraw,->(user_id){where(receiver_id:user_id)}
  
  scope :by_date, ->(start_date: nil, end_date: nil) {
    scope = all

    if start_date.present?
      scope = scope.where(
        "created_at >= ?",
        start_date.to_date.beginning_of_day
      )
    end

    if end_date.present?
      scope = scope.where(
        "created_at <= ?",
        end_date.to_date.end_of_day
      )
    end
    scope
  }


  scope :by_sender_currency,->(sender_currency){
    scope=all
    scope=scope.where(from_currency:sender_currency.downcase) if sender_currency.present?
    scope
  }

  scope :by_receiver_currency,->(receiver_currency){
    scope=all
    scope=scope.where(to_currency:receiver_currency.downcase) if receiver_currency.present?
    scope 
  }

  scope :filter, ->(user_id, params = {}) {
    scope = all_transactions(user_id)

    # deposit / withdraw
    scope =
      case params[:type]
      when "deposit"
        scope.deposit(user_id)
      when "withdraw"
        scope.withdraw(user_id)
      else
        scope
      end

    scope
      .by_balance(
        min_balance: params[:min_balance],
        max_balance: params[:max_balance]
      )
      .by_date(
        start_date: params[:start_date],
        end_date: params[:end_date]
      )
      .by_sender_currency(params[:sender_currency_code])
      .by_receiver_currency(params[:receiver_currency_code])
  }

end