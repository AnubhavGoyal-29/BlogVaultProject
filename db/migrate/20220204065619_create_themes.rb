class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :theme_name
      t.string :theme_slug
      t.string :url_id
      t.boolean :status
      t.string :version
      t.string :other_data
      t.integer :first_seen
      t.integer :last_seen
      t.timestamps
    end
  end
end
