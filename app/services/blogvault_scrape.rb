class BlogvaultScrape
  def initialize(urls)
    puts 'from blogvault scrape'
    data = filter_cms(urls)
    #ids  =  Url.import_urls(data[0])
    start_scrape(data)
  end
  
  def filter_cms(urls)
    filterCms = FilterCms.new(urls)
    data = filterCms.start_filter
    return data
  end

  def start_scrape(data)
    getSiteData = GetSiteData.new(data)
    getSiteData.start_scrape
  end
end
