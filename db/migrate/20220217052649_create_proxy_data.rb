class CreateProxyData < ActiveRecord::Migration[5.2]
  def change
    create_table :proxy_data do |t|
      
      t.string :host
      t.timestamps
    end
  end
end
