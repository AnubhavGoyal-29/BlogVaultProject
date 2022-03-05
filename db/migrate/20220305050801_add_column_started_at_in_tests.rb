class AddColumnStartedAtInTests < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :started_at, :timestamp
  end
end
