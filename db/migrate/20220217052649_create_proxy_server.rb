class CreateProxyServer < ActiveRecord::Migration[5.2]
  def change
    create_table :proxy_data do |t|
      
      t.string :host
      t.string :port
      t.string :username
      t.string :password
      t.timestamps
    end
  end
end
