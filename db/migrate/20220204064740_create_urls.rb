class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :url, index: true, unique: true
      t.references :site_data_info,index: true, foreign_key: true
      t.timestamps
    end
  end
end
