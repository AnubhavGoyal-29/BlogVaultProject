class JsInfo < ApplicationRecord

  belongs_to :url , default: nil

  def self.import_js(js,_url)
    puts "called js from update database"
    puts js.count
    id = []
    js.each do |i|
      _js = JsInfo.where(js_name:i,url_id:_url,status:1).first
      if _js
        _version = _js.version
        if  _version != i[1]
          _js.status = 0
          _js.save
          new_js = JsInfo.create(js_name:i[0],url_id:_url,status:1,version:i[1])
          id << new_js.id
        else
          id << _js.id
        end
      else
        new_js = JsInfo.create(js_name:i,url_id:_url,status:1,version:i[1])
        id << new_js.id
      end
    end
    return id
  end

end
