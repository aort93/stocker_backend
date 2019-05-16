class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :symbol
      t.string :bio
      t.string :ceo
      t.integer :founding_year
      t.integer :employee_count
      t.string :location
      t.integer :current_stock_price

      t.timestamps
    end
  end
end
