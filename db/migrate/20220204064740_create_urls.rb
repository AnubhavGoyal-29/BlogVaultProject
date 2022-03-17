class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :url, index: true, unique: true
      t.integer :first_test
      t.string :cms
      t.timestamps
    end
  end
end
