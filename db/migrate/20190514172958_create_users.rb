class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password_digest
      t.float :stocks_value
      t.float :cash_value
      t.float :original_cash_value

      t.timestamps
    end
  end
end
