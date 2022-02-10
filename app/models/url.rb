class Url < ApplicationRecord
  has_and_belongs_to_many :test, required: false
  has_many :plugins
  has_many :themes

  def self.import_urls(data)
    puts "called"
    urls = []
    html = []
    for i in 0..data[0].size-1
      _url = Url.where(url:data[0][i]).first
      if !_url
        _url = Url.create(url:data[0][i],test_id: nil)
        urls << data[0][i]
        html << data[1][i]
      end
    end
    puts "data from urls"
    return [ urls, html ] 
  end

end
