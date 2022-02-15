class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.integer :status
      t.integer :number_of_urls
      t.integer :total_jobs
      t.integer :completed_jobs
      t.timestamps
    end
  end
end
