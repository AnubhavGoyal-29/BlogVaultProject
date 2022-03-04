class AddColumnFirstSeenToUrls < ActiveRecord::Migration[5.2]
  def change
    add_column :urls, :first_seen, :string
  end
end
