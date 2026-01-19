class Wallet < ApplicationRecord
  belongs_to :user

  # Money leaving wallet
  has_many :withdrawal_transactions,
           class_name: 'Transaction',
           foreign_key: :sender_wallet_id,
           dependent: :restrict_with_error


  # Money entering wallet
  has_many :deposit_transactions,
           class_name: 'Transaction',
           foreign_key: :receiver_wallet_id,
           dependent: :restrict_with_error

  enum currency_code: CURRENCY_ENUM, _prefix: true

  validates :currency_code,
             uniqueness: { 
              scope: :user_id,
              message: "wallet already exists for this currency"
            }

  validates :balance,
             numericality: { 
              greater_than_or_equal_to: 0
            }

  scope :by_currency, ->(currency) {
    where(currency_code: currency) if currency.present?
  }

  scope :by_balance, ->(min_balance: nil, max_balance: nil) {
    scope = all
    scope = scope.where("balance >= ?", min_balance) if min_balance.present?
    scope = scope.where("balance <= ?", max_balance) if max_balance.present?
    scope
  }

  
  scope :filtered, ->(params = {}) {
    scope = all
    scope = scope.by_currency(params[:currency_code])
    
    scope = scope.by_balance(
      min_balance: params[:min_balance],
      max_balance: params[:max_balance]
    )
    scope
  }


end
