class Plugin < ApplicationRecord
  belongs_to :url , default: nil

  def self.import_plugins(plugin,_url)
    
    plugin.each do |i|
      _plugin = Plugin.where(plugin_name:i[0],url_id:_url,status:1).first
      if _plugin 
        _version = _plugin.version
        if  _version != i[1]
          _plugin.status = 0 
          _plugin.save
          Plugin.create(plugin_name:i[0],url_id:_url,status:1,version:i[1])
        end
      else
        Plugin.create(plugin_name:i[0],url_id:_url,status:1,version:i[1])
      end
    end
  end
end
