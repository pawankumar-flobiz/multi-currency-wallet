class NotificationMailer < ApplicationMailer
  def send_notification
    @user=params[:user]
    @transaction=params[:transaction]
    @message_type=params[:message_type]
    mail(
      to:@user.email,
      subject:"Transaction Details"
    )
  end

  def daily_balance(user)
    @user=user
    @wallets=user.wallets
    mail(
      to: user.email,
      subject: "Your Daily Wallet Balance"
    )
  end
end
