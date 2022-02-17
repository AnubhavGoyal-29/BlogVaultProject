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
    puts site_data_objects
    SiteDataInfo.import site_data_objects

    Url.all.each do |url|
      begin
        url.site_data_info_id = SiteDataInfo.where(test_id: test, url_id: url.id).first.id
        url.save!
      rescue => e
        logger.info e
      end
    end

    logger.info "database update completed for #{id} "


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
