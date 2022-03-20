class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.integer :status
      t.integer :number_of_websites
      t.timestamp :started_at
      t.timestamps
    end
  end
end
