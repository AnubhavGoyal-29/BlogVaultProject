class CreateJs < ActiveRecord::Migration[5.2]
  def change
    create_table :js do |t|
      t.string :js_name
      t.string :url_id
      t.string :status

      t.timestamps
    end
  end
end

