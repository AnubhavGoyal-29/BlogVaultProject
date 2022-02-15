class BlogvaultScrapingJob < ApplicationJob
  QUEUE = :my_worker_queue

  def logger
      @logger ||= Logger.new("log/testing.log")
  end

  def perform(urls,test)
    logger.info "Blogvault Scraping Job Started"
    data = Scrape::filter_wp_urls(urls, logger)             # here data will be maped agains url id from our database tables
    data = Scrape::scrape_html(data, logger)
    SiteDataInfo.import_data(test, data)
    test = Test.find(test)
    if (test.completed_jobs + 1) == test.total_jobs
      puts "completed"
      test.completed_jobs += 1
      test.status = 1
      test.save!
    else
      test.completed_jobs += 1
      test.save!
    end
    puts "done"
  end

end
