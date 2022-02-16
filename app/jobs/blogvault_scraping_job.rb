class BlogvaultScrapingJob < ApplicationJob
  QUEUE = :my_worker_queue

  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def perform(urls, test)
    logger.info "Blogvault Scraping Job Started"
    data = Scrape::filter_wp_urls(urls, logger)             # here data will be maped agains url id from our database tables
    data = Scrape::scrape_html(data, logger)
    SiteDataInfo.import_data(test, data)
    if Resque.redis.lrange("queue:#{'default'}",0,-1).count == 0 && Resque.info[:working] == 1
        test = Test.find(test)
        test.status = 1
        test.save!
        puts "completed"
    else 
      puts Resque.redis.lrange("queue:#{'default'}",0,-1).count
      puts Resque.info[:working]
    end
  end

end
