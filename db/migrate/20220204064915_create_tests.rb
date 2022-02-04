class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.integer :url_id 
      t.integer :data_id

      t.timestamps
    end
  end
end
