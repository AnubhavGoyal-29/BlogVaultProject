class TestsUrlsTable < ActiveRecord::Migration[5.2]
    create_table :tests_urls, id: false do |t|
      t.belongs_to :test
      t.belongs_to :url
    end
end
