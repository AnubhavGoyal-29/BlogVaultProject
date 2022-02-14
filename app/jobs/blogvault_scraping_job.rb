class BlogvaultScrapingJob < ApplicationJob
  QUEUE = :my_worker_queue

  def logger
      @logger ||= Logger.new("log/testing.log")
  end

  def perform(urls,test)
    logger.info "FILTERING_OF_URLS_IS_STARTING"
    @test = test
    data = filter_wordpress_sites(urls)
    Url.import_urls(data)
    start_scrape(data)
  end

  def filter_wordpress_sites(urls)
    data = FilterCms::start_filter_wordpress_sites(urls)             # here data is a map and contains html and version again wordpress site url
    return data
  end

  # scraping site data here 
  # updating the data in database
  def start_scrape(data)
    finalData = GetSiteData::start_scraping_html(data)
    UpdateDatabase::update_data(@test,finalData)
  end
end
