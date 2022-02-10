class BlogvaultScrapingJob < ApplicationJob
  @queue = :my_worker_queue
  def perform(urls,test)
    @test = test
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
  end
end
