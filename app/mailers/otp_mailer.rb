class OtpMailer < ApplicationMailer
  def send_otp
    @user=params[:user]
    @otp = @user.otp_code
    @expiry=Settings.otp.expiry.to_i
    mail(
      to:@user.email,
      subject:"Verification Code"
    )
  end
end
