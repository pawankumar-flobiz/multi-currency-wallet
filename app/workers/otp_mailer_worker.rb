class OtpMailerWorker 
  include Sidekiq::Worker
  sidekiq_options queue: :mailers,retry: 2

  def perform(user_id)
    user=User.find_by(id:user_id)
    return unless user
    OtpMailer.with(user:user).send_otp.deliver_now
  end

end