class BlogvaultScrapingJob < ApplicationJob
  QUEUE = :my_worker_queue

  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def perform(urls, test_id, step_id)
    logger.info "Test Id: #{test_id} \nBlogvault Scraping Job : #{step_id} \nMessage: Started"
    Step.find(step_id).update(:status => Step::Status::RUNNING)
    #each url in urls will store [url, id]

    data = Scrape::filter_wp_urls(urls, logger)     # here data will be maped agains url id from our database tables
    logger.info "Test Id: #{test_id} \nStep Id : #{step_id} \nMessage: Filter completed"
    data = Scrape::scrape_html(data, logger)
    logger.info "Test Id: #{test_id} \Step Id : #{step_id} \nMessage: Scraping completed"
    site_data_objects = SiteDataInfo.import_data(test_id, data, logger)
    logger.info "Test Id: #{test_id} \nStep Id : #{step_id} \nMessage: Url update started"
    TestCompletionJob.perform_now(logger, test_id, step_id)
  rescue => e
    Step.find(step_id).update(:status => Step::Status::FAILED)
    Test.find(test_id).update(:status => Test::Status::FAILED)
    logger.info "Test Id: #{test_id} \nStep Id : #{step_id} \nError: #{e}"
  end

end
