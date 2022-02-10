class CreateTestDataInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :test_data_infos do |t|
      t.references :url,index: true, foreign_key: true
      t.references :site_data,index: true, foreign_key: true
      t.integer :t_no
      t.timestamps
    end
  end
end
