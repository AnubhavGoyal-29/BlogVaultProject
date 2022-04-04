class V2::JsInfo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :website
  field :js_lib, type: String
  field :is_active, type: Boolean
  field :version, type: String
  field :first_test, type: String
  field :last_test, type: String
  def self.test
    @test ||= V2::Test.find(@test_id)
  end

  def self.import_js(all_js, website_id, test_id, logger)
    js_id = []
    @test_id = test_id
    all_js.each do |js|
      _js = V2::JsInfo.where(:js_lib => js[:js_lib], :website_id => website_id, :is_active => true).first
      if _js
        _version = _js.version
        if  _version != js[:version]
          _js.is_active = false
          _js.save
          new_js = V2::JsInfo.create(:first_test => test.number, :last_test => test.number, :js_lib => js[:js_lib],
                                     :website_id => website_id, :is_active => true, :version => js[:version] )
          js_id << new_js.id
        else
          _js.update(:last_test => test.number)
          js_id << _js.id
        end
      else
        new_js = V2::JsInfo.create(:first_test => test.number, :last_test => test.number, :js_lib => js[:js_lib],
                                   :website_id => website_id, :is_active => true, :version => js[:version] )
        js_id << new_js.id
      end
    end
    last_js = V2::SiteDataInfo.where(:website => website_id).last&.js_ids
    inactive_removed_js(last_js, js_id) if last_js.present?
    return js_id
  rescue => e
    logger.info e
  end

  def self.inactive_removed_js(last_js, js_id)
    removed_js = last_js - js_id
    removed_js.each do |id|
      V2::JsInfo.find(id).update(:is_active => false)
    end
  end

end
