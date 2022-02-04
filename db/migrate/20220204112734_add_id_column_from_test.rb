class AddIdColumnFromTest < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :id , :integer, null: false, unique: true, auto_increment: true,  primary_key: true
  end
end
