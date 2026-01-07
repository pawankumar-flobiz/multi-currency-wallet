class User < ApplicationRecord
  has_secure_password
  has_many :wallets
  has_many :sent_transactions, class_name: 'Transaction', foreign_key: :user_id
  has_many :received_transactions, class_name: 'Transaction', foreign_key: :receiver_id
end
