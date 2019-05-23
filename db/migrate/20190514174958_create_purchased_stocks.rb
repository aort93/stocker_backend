class CreatePurchasedStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :purchased_stocks do |t|
      t.integer :user_id
      t.integer :company_id
      t.date :date_purchased
      t.integer :shares
      t.integer :curret_shares
      t.float :price

      t.timestamps
    end
  end
end
