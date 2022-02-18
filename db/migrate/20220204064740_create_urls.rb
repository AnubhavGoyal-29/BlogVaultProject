class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :url, index: true, unique: true
      t.string :site_data_info_id
      t.timestamps
    end
  end
end
