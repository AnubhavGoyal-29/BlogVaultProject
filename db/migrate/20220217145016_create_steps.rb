class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.integer :status
      t.string :urls
      t.string :test_id
      t.timestamps
    end
  end
end
