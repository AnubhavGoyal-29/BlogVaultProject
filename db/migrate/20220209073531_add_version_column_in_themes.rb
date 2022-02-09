class AddVersionColumnInThemes < ActiveRecord::Migration[5.2]
  def change
    add_column :themes, :version, :string
  end
end
