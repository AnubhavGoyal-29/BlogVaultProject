class CreateJsInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :js_infos do |t|
      t.text :js_lib
      t.string :url_id
      t.boolean :status
      t.string :version
      t.string :other_data
      t.integer :first_test
      t.integer :last_test
      t.timestamps
    end
  end
end

