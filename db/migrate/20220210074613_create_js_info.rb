class CreateJsInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :js_infos do |t|
      t.string :js_name
      t.string :url_id
      t.string :test_id
      t.integer :status
      t.string :version
      t.string :other_data
      t.timestamps
    end
  end
end

