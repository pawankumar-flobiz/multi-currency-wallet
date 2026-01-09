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

  validates :currency_code, uniqueness: { scope: :user_id }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

end
