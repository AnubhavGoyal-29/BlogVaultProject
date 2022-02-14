class BlogvaultScrape
  
  def logger
      @logger ||= Logger.new("log/testing.log")
  end
  
  def initialize(urls, testNo)
    @testNo = testNo
    logger.info "Test #{@testNo} started"
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
    logger.info "final_data"
    UpdateDatabase.new.update_data(@testNo, final_data)
    logger.info "Test #{@testNo} completed"
    logger.info final_data
  end
end
