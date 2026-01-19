class TransactionNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mailers,retry: 2

  def perform(user_id, transaction_id, message_type)
    user = User.find(user_id)
    transaction = Transaction.find(transaction_id)

    NotificationMailer
      .with(
        user: user,
        transaction: transaction,
        message_type: message_type
      )
      .send_notification
      .deliver_now
  end
end