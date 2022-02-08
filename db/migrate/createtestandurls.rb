class CreateTestsAndUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :tests_urls   , id: false do |t|
      t.belongs_to :tests
      t.belongs_to :urls
    end
  end
end

