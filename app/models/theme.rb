class Theme < ApplicationRecord
  belongs_to :url , default: nil

  def self.import_themes(themes, _url, test_id )
    themes_id = []
    themes.each do |slug|
      _theme = Theme.where(theme_slug: slug, url_id: _url, status: true).first
      if _theme
        _version = _theme.version
        # passing 1.1 for testing only
        # finding ways to find version effectively
        if  _version != '1.1'
          _theme.status = false
          _theme.save
          theme_name = ThemeSlug.where(:slug => slug).first&.name || slug
          new_theme = Theme.create(:first_seen => test_id, :last_seen => test_id, :theme_name => theme_name,
                                   :theme_slug => slug, :url_id => _url, :status => true, :version => '1.1')
          themes_id << new_theme.id
        else
          _theme.update(:last_seen => test_id)
          themes_id << _theme.id
        end
      else
        theme_name = ThemeSlug.where(:slug => slug).first&.name || slug
        new_theme = Theme.create(:first_seen => test_id, :last_seen => test_id, :theme_name => theme_name,
                                 :theme_slug => slug, :url_id => _url, :status => true, :version => '1.1')
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
      Theme.find(id).update(:status => false)
    end
    return true
  end
end
