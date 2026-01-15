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

  scope :by_sender,->(sender_id){where(user_id:sender_id)}
  scope :by_receiver,->(receiver_id){where(receiver_id:receiver_id)}
  
  scope :by_date, ->(start_date, end_date) do
    if !start_date.nil? && !end_date.nil?
      where(created_at: start_date..end_date)
    elsif !start_date.nil?
      where("created_at >= ?", start_date)
    elsif !end_date.nil?
      where("created_at <= ?", end_date)
    else
      all
    end
  end

  scope :by_sender_currency,->(sender_currency){where(from_currency:sender_currency.downcase)}
  scope :by_receiver_currency,->(receiver_currency){where(to_currency:receiver_currency.downcase)}

end