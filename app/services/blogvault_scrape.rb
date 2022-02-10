class BlogvaultScrape
  def initialize(urls,testNo)
    @testNo = testNo
    puts "test #{testNo} started"
    data = filter_cms(urls)
    ids  =  Url.import_urls(data)
    start_scrape(ids)
  end
  
  def filter_cms(urls)
    filterCms = FilterCms.new(urls)
    data = filterCms.start_filter
    return data
  end

  def start_scrape(data)
    getSiteData = GetSiteData.new(data)
    final_data = getSiteData.start_scrape
    puts "Test #{@testNo} completed"
    puts final_data
  end
end
