class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :receiver_id, null: false

      t.uuid :sender_wallet_id, null: false
      t.uuid :receiver_wallet_id, null: false

      t.decimal :amount, precision: 15, scale: 2, null: false
      t.integer :from_currency, null: false
      t.integer :to_currency, null: false
      t.decimal :exchange_rate, precision: 15, scale: 6, null: false
      t.decimal :fee, precision: 15, scale: 2, default: 0, null: false
      t.decimal :total_debit, precision: 15, scale: 2, null: false

      t.timestamps
    end

    add_foreign_key :transactions, :users
    add_foreign_key :transactions, :users, column: :receiver_id
    add_foreign_key :transactions, :wallets, column: :sender_wallet_id
    add_foreign_key :transactions, :wallets, column: :receiver_wallet_id
  end
end
