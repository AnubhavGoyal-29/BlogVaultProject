class ThemesUrlReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :themes, :urls, foreign_key: true
  end
end
