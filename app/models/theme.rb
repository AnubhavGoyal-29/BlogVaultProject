class Theme < ApplicationRecord
  belongs_to :url , default: nil

  module Status
    ACTIVE = 1
    INACTIVE = 0
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

  def self.import_themes(themes, _url, test_id )
    themes_id = []
    themes.each do |theme|
      _theme = Theme.where(theme_name: theme, url_id: _url, status: 1).first
      if _theme
        _version = _theme.version
        # passing 1.1 for testing only
        # finding ways to find version effectively
        if  _version != '1.1'
          _theme.status = 0
          _theme.save
          new_theme = Theme.create(:first_seen => test_id, :last_seen => test_id, theme_name: theme, url_id: _url, status: 1, version: '1.1')
          themes_id << new_theme.id
        else
          _theme.update(:last_seen => test_id)
          themes_id << _theme.id
        end
      else
        new_theme = Theme.create(:first_seen => test_id, :last_seen => test_id, theme_name: theme, url_id: _url, status: 1, version: '1.1')
        themes_id << new_theme.id
      end
    end
    last_themes = Url.find(_url).site_data_infos.last.themes if Url.find(_url) and Url.find(_url).site_data_infos.last
    done = inactive_removed_themes(JSON.parse(last_themes), themes_id) if last_themes
    return themes_id
  end

  def self.inactive_removed_themes(last_themes, themes_id)
    removed_themes = last_themes - themes_id
    removed_themes.each do |id|
      Theme.find(id).update(:status => Theme::Status::INACTIVE)
    end
    return true
  end
end
