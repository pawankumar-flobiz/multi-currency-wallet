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
end
