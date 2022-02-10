class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :theme_name
      t.string :url_id
      t.string :status
      t.string :version
      t.string :other_data
      t.timestamps
    end
  end
end
