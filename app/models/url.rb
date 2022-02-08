class Url < ApplicationRecord
  has_and_belongs_to_many :test, required: false
  has_many :plugins
  has_many :themes

  def self.import_urls(urls)
    puts "called"
    ids = []
    urls.each do |i|
      _url = Url.where(url:i).first
      if !_url
        _url = Url.create(url:i,test_id: nil)
        ids << _url.id
      end
    end
    return ids
  end

end
