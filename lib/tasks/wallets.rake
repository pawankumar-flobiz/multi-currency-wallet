namespace :wallets do
  desc "Send daily wallet balance to all users"
  task send_daily_balance: :environment do
    User.active.find_each(batch_size:50) do |user|
      SendWalletBalanceJob.perform_later(user.id)
    end
  end
end
