class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :theme_name
      t.string :theme_slug
      t.string :website_id
      t.boolean :is_active
      t.string :version
      t.string :other_data
      t.integer :first_test
      t.integer :last_test
      t.timestamps
    end
  end
end
