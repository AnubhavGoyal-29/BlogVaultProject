class AddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :t_no, :integer
    add_reference :tests, :url, index: true, foreign_key: true
  end
end
