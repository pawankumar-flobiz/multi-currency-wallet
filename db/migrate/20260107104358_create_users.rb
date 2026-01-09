class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      # active_model_otp
      t.string   :otp_secret
      t.datetime :otp_sent_at
      t.datetime :email_verified_at

      # soft delete
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users,
              :email,
              unique: true,
              where: "deleted_at IS NULL"
  end
end
