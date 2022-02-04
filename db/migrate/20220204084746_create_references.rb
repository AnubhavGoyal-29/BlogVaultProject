class CreateReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :plugins, :url, index: true, foreign_key: true
    add_reference :themes, :url, index: true, foreign_key: true
  end
end
