class SendWalletBalanceJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    if user.wallets.count >= 1
      NotificationMailer.daily_balance(user).deliver_now
    end
  end
end
