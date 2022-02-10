class Theme < ApplicationRecord
belongs_to :url , default: nil

  def self.import_themes(theme,_url)
    puts "call theme from update database"
    id = []
    theme.each do |i|
      _theme = Theme.where(theme_name:i,url_id:_url,status:1).first
      if _theme
        _version = _theme.version
        if  _version != i[1]
          _theme.status = 0
          _theme.save
          new_theme = Theme.create(theme_name:i[0],url_id:_url,status:1,version:i[1])
          id << new_theme.id
        else
          id << _theme.id
        end
      else
       new_theme = Theme.create(theme_name:i[0],url_id:_url,status:1,version:i[1])
       id << new_theme.id
      end
    end
    return id
  end
end
