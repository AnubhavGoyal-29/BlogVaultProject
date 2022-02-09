class GetSiteData
  def initialize(data)
    puts 'i am get site data'
    @data = data
  end
  def start_scrape
    puts @data.size
    for i in 0..@data.size
      puts @data[0][i]
    end
  end
end
