class JsInfo < ApplicationRecord
  belongs_to :website, default: nil

  def self.import_js(all_js, website_id, test_id, logger)
    js_id = []
    all_js.each do |js|
      _js = JsInfo.where(:js_lib => js[:js_lib], :website_id => website_id, :is_active => true).first
      if _js
        _version = _js.version
        if  _version != js[:version]
          _js.is_active = false
          _js.save
          new_js = JsInfo.create(:first_test => test_id, :last_test => test_id, :js_lib => js[:js_lib], 
                                 :website_id => website_id, :is_active => true, :version => js[:version] )
          js_id << new_js.id
        else
          _js.update(:last_test => test_id)
          js_id << _js.id
        end
      else
        new_js = JsInfo.create(:first_test => test_id, :last_test => test_id, :js_lib => js[:js_lib], 
                               :website_id => website_id, :is_active => true, :version => js[:version] )
        js_id << new_js.id
      end
    end
    last_js = Website.find(website_id)&.site_data_infos.last&.js_ids
    inactive_removed_js(last_js, js_id) if last_js.present?
    return js_id
  rescue => e
    logger.info e
  end

  def self.inactive_removed_js(last_js, js_id)
    removed_js = last_js - js_id
    removed_js.each do |id|
      JsInfo.find(id).update(:is_active => false)
    end
  end
end
