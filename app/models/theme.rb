class Theme < ApplicationRecord
belongs_to :url , default: nil

  def self.import_themes(theme,_url)

    theme.each do |i|
      _theme = Theme.where(theme_name:i[0],url_id:_url,status:1).first
      if _theme
        _version = _theme.version
        if  _version != i[1]
          _theme.status = 0
          _theme.save
          Theme.create(theme_name:i[0],url_id:_url,status:1,version:i[1])
        end
      else
        Theme.create(theme_name:i[0],url_id:_url,status:1,version:i[1])
      end
    end
  end
end
