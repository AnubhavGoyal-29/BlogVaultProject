class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.string :status
      t.string :number_of_urls
      t.timestamps
    end
  end
end
