class CreateThemeSlugs < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_slugs do |t|
      t.string :name
      t.string :slug, index: true
      t.timestamps
    end
  end
end
