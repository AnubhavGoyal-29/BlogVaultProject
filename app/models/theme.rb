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

  def self.import_themes(themes, _url)
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
          new_theme = Theme.create(theme_name: theme, url_id: _url, status: 1, version: '1.1')
          themes_id << new_theme.id
        else
          themes_id << _theme.id
        end
      else
        new_theme = Theme.create(theme_name: theme, url_id: _url, status: 1, version: '1.1')
        themes_id << new_theme.id
      end
    end
    return themes_id
  end
end
