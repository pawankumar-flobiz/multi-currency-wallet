class User < ApplicationRecord
  has_secure_password
  has_one_time_password
  
  has_many :wallets, dependent: :restrict_with_error

  has_many :sent_transactions,
          class_name: 'Transaction',
          foreign_key: :user_id,
          dependent: :restrict_with_error

  has_many :received_transactions,
           class_name: 'Transaction',
           foreign_key: :receiver_id,
           dependent: :restrict_with_error
end           
