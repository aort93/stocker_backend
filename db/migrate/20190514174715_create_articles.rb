class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :headline
      t.string :link_url
      t.date :date
      t.string :summary
      t.string :img_url
      t.integer :company_id

      t.timestamps
    end
  end
end
