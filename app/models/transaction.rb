class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :sender_wallet, class_name: 'Wallet', foreign_key: 'sender_wallet_id'
  belongs_to :receiver_wallet, class_name: 'Wallet', foreign_key: 'receiver_wallet_id'

  enum from_currency: { INR: 0, USD: 1, EUR: 2 }
  enum to_currency:   { INR: 0, USD: 1, EUR: 2 }
end
