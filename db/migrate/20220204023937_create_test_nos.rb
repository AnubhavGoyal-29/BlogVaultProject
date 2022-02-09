class CreateTestNos < ActiveRecord::Migration[5.2]
  def change
    create_table :test_nos do |t|
      t.integer :status
      t.integer :number_of_urls

      t.timestamps
    end
  end
end
