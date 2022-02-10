class J < ApplicationRecord

  belongs_to :url , default: nil

  def self.import_themes(js,_url)
    id = []
    theme.each do |i|
      _js = J.where(js_name:i[0],url_id:_url,status:1).first
      if _js
        _version = _js.version
        if  _version != i[1]
          _js.status = 0
          _js.save
          js = J.create(js_name:i[0],url_id:_url,status:1,version:i[1])
          id << js.id
        else
          id << _js.id
        end
      else
        js = J.create(theme_name:i[0],url_id:_url,status:1,version:i[1])
      end
    end
    return id
  end

end
