class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.string :status
      t.integer :total_urls
      t.references :test, index: true, foreign_key: true
      t.timestamps
    end
  end
end
