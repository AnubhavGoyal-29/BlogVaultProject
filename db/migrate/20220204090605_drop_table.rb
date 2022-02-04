class DropTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :data
  end
end
