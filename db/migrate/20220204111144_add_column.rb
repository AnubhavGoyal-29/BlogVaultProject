class AddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :t_no, :integer
  end
end
