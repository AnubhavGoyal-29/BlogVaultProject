class RemoveMoreReferences < ActiveRecord::Migration[5.2]
  def change
    remove_reference :tests, :datum, index: true, foreign_key: true
  end
end
