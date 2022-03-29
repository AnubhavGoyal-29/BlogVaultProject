class Theme < ApplicationRecord
  belongs_to :website , default: nil

  def self.import_themes(themes, website_id, test_id )
    themes_id = []
    themes.each do |slug|
      _theme = V2::Theme.where(:theme_slug => slug, :website_id => website_id, :is_active => true).first
      if _theme
        _version = _theme.version
        # passing 1.1 for testing only
        # finding ways to find version effectively
        if  _version != '1.1'
          _theme.is_active = false
          _theme.save
          theme_name = V2::ThemeSlug.where(:slug => slug).first&.name || slug
          new_theme = V2::Theme.create(:first_test => test_id, :last_test => test_id, :theme_name => theme_name,
                                   :theme_slug => slug, :website_id => website_id, :is_active => true, :version => '1.1')
          themes_id << new_theme.id
        else
          _theme.update(:last_test => test_id)
          themes_id << _theme.id
        end
      else
        theme_name = V2::ThemeSlug.where(:slug => slug).first&.name || slug
        new_theme = V2::Theme.create(:first_test => test_id, :last_test => test_id, :theme_name => theme_name,
                                 :theme_slug => slug, :website_id => website_id, :is_active => true, :version => '1.1')
        themes_id << new_theme.id
      end
    end
    last_themes = V2::SiteDataInfo.where(:website => website_id).last&.theme_ids
    inactive_removed_themes(last_themes, themes_id) if last_themes
    return themes_id
  end

  def self.inactive_removed_themes(last_themes, themes_id)
    removed_themes = last_themes - themes_id
    removed_themes.each do |id|
      V2::Theme.find(id).update(:is_active => false)
    end
  end
end
