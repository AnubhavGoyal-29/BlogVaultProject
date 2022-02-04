class RemoveReferencesAgain < ActiveRecord::Migration[5.2]
  def change
    remove_reference :tests, :urls, index: true, foreign_key: true
  end
end
