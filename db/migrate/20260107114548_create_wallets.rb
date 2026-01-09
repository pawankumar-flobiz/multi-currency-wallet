class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets, id: :uuid do |t|
      t.uuid    :user_id, null: false
      t.decimal :balance, precision: 15, scale: 2, default: 0, null: false
      t.integer :currency_code, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :wallets,
              [:user_id, :currency_code],
              unique: true,
              where: "deleted_at IS NULL"

    add_foreign_key :wallets, :users
  end
end
