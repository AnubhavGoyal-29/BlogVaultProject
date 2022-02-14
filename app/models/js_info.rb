class JsInfo < ApplicationRecord

  belongs_to :url , default: nil

  def self.import_js(all_js, _url)
    js_id = []
    all_js.each do |js|
      _js = JsInfo.where(js_name: js, url_id: _url, status: 1).first
      if _js
        _version = _js.version
        # version 1.1 is used for testing only
        # finding better way to find js version
        if  _version != '1.1'
          _js.status = 0
          _js.save
          new_js = JsInfo.create(js_name: js, url_id: _url, status: 1, version: '1.1')
          js_id << new_js.id
        else
          js_id << _js.id
        end
      else
        new_js = JsInfo.create(js_name: js, url_id: _url,status: 1,version: '1.1')
        js_id << new_js.id
      end
    end
    return js_id
  end

end
