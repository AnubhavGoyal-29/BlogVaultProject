class V2::Theme
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :website
  field :theme_name, type: String
  field :theme_slug, type: String
  field :is_active, type: Boolean
  field :first_test, type: String
  field :last_test, type: String
  def self.test
    @test ||= V2::Test.find(@test_id)
  end

  def self.import_themes(themes, website_id, test_id )
    themes_id = []
    @test_id = test_id
    themes.each do |slug|
      _theme = V2::Theme.where(:theme_slug => slug, :website_id => website_id, :is_active => true).first
      if _theme
        _version = '1.1'
        # passing 1.1 for testing only
        # finding ways to find version effectively
        if  _version != '1.1'
          _theme.is_active = false
          _theme.save
          theme_name = V2::ThemeSlug.where(:slug => slug).first&.name || slug
          new_theme = V2::Theme.create(:first_test => test.number, :last_test => test.number, :theme_name => theme_name,
                                       :theme_slug => slug, :website_id => website_id, :is_active => true)
          themes_id << new_theme.id
        else
          _theme.update(:last_test => test.number)
          themes_id << _theme.id
        end
      else
        theme_name = V2::ThemeSlug.where(:slug => slug).first&.name || slug
        new_theme = V2::Theme.create(:first_test => test.number, :last_test => test.number, :theme_name => theme_name,
                                     :theme_slug => slug, :website_id => website_id, :is_active => true)
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

  def history(start_date, end_date)
    hash = {}
    V2::Test.where({:created_at.gte => start_date, :updated_at.lte => end_date}).all.each do |test|
      args = {}
      args[:theme_slug] = self.theme_slug
      args[:first_test] = -Float::INFINITY..test.number.to_i
      args[:last_test] = test.number.to_i..Float::INFINITY
      count = V2::Theme.where(args).count
      hash[test.number] = count
    end
    return hash
  end

end
