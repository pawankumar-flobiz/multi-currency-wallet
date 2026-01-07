class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      

      t.bigint :sender_wallet_id
      t.bigint :receiver_wallet_id

      t.decimal :amount, precision: 15, scale: 2 ,null: false

      t.integer :from_currency ,null: false
      t.integer :to_currency, null:false

      t.decimal :exchange_rate, precision: 15, scale: 2
      t.decimal :fee, precision: 15, scale: 2
      t.decimal :total_debit, precision: 15, scale: 2

      t.timestamps
    end

    add_index :transactions, :sender_wallet_id
    add_index :transactions, :receiver_wallet_id

    add_foreign_key :transactions, :wallets,column: :sender_wallet_id
    add_foreign_key :transactions, :wallets,column: :receiver_wallet_id
  end
end
