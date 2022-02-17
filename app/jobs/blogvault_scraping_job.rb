class BlogvaultScrapingJob < ApplicationJob
  QUEUE = :my_worker_queue

  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def perform(urls, test, id)
    logger.info "Blogvault Scraping Job #{id} Started"
    data = Scrape::filter_wp_urls(urls, logger)             # here data will be maped agains url id from our database tables
    logger.info "filter complete"
    data = Scrape::scrape_html(data, logger)
    logger.info "scraping complete"
    site_data_objects = SiteDataInfo.import_data(test, data, logger, id)
    SiteDataInfo.import site_data_objects
    logger.info "url update started"
=begin
    if Resque.redis.lrange("queue:#{'default'}",0,-1).count == 0 && Resque.info[:working] == 1
        test = Test.find(test)
        test.status = 1
        test.save!
        puts "completed"
    else 
      puts Resque.redis.lrange("queue:#{'default'}",0,-1).count
      puts Resque.info[:working]
    end
=end
  end

end
