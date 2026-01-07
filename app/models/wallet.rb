class Wallet < ApplicationRecord
  belongs_to :user

  has_many :sent_transactions, class_name: 'Transaction', foreign_key: 'sender_wallet_id'
  has_many :received_transactions, class_name: 'Transaction', foreign_key: 'receiver_wallet_id'

  enum currency_code: { INR: 0, USD: 1, EUR: 2 }
end
