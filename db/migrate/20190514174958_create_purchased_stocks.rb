class CreatePurchasedStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :purchased_stocks do |t|
      t.integer :user_id
      t.integer :company_id
      t.string :date_purchased
      t.integer :shares
      t.integer :price

      t.timestamps
    end
  end
end
