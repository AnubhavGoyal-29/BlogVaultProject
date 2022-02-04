class UrlTestReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :urls, :tests, foreign_key: true
  end
end
