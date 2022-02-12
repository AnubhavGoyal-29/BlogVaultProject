class BlogvaultScrapingJob < ApplicationJob
  QUEUE = :my_worker_queue

  def perform(urls,test)
    @test = test
    data = filter_wordpress_sites(urls)
    data =  Url.import_urls(data)
    start_scrape(data)
  end

  def filter_wordpress_sites(urls)
    data = FilterCms::start_filter_wordpress_sites(urls)             # here we get three things [[url,html,[wordpress,version]]]
    return data
  end

  # scraping site data here 
  # updating the data in database
  def start_scrape(data)
    finalData = GetSiteData::start_scraping_html(data)
    UpdateDatabase::update_data(@test,finalData)
  end
end
