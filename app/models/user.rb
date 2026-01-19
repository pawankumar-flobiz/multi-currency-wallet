class User < ApplicationRecord
  has_secure_password
  has_one_time_password interval:Settings.otp.expiry.to_i*60 #convert minute in second so that otp will refresh at that interval
  
  has_many :wallets, dependent: :restrict_with_error

  has_many :sent_transactions,
          class_name: 'Transaction',
          foreign_key: :user_id,
          dependent: :restrict_with_error

  has_many :received_transactions,
           class_name: 'Transaction',
           foreign_key: :receiver_id,
           dependent: :restrict_with_error

  validates :name, presence: true
  validates  :email, presence: true ,
                uniqueness: {
                    condition: ->{where(deleted_at:nil)}    
                }

  validates :password, presence: true, on: :create

  scope :active, ->{ where( deleted_at: nil) }  

  scope :by_name, ->(name){
    where("name ILIKE ?", "%#{name}%") if name.present?
  }

  scope :by_email, ->(email){where(email:email.downcase)}

  def email_verified?
    email_verified_at.present?
  end
end           
