class RenameOtpSecretToOtpSecretKey < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :otp_secret, :otp_secret_key
  end
end
