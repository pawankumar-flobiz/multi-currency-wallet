class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      
      t.references :user, null: false, foreign_key: true

      t.decimal :balance ,precision: 15,scale: 2,default: 0,null: false
      
      t.integer :currency_code

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :wallets,[:user_id, :currency_code], unique: true
  end
end
