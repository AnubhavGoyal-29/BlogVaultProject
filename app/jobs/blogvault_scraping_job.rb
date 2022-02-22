class BlogvaultScrapingJob < ApplicationJob
  QUEUE = :my_worker_queue

  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def perform(urls, test_id, step_id)
    logger.info "Blogvault Scraping Job #{step_id} Started"
    Step.find(step_id).update(:status => Step::STATUS.invert[:RUNNING])
    #each url in urls will store [url, id]

    data = Scrape::filter_wp_urls(urls, logger)     # here data will be maped agains url id from our database tables

    logger.info data.count
    logger.info "filter complete"
    data = Scrape::scrape_html(data, logger)
    logger.info "scraping complete"
    site_data_objects = SiteDataInfo.import_data(test_id, data, logger)
    logger.info "url update started"
    TestCompletionJob.perform_now(logger, test_id, step_id)
  rescue => e
    Step.find(step_id).update(:status => Step::STATUS.invert[:FAILED])
    Test.find(test_id).update(:status => Test::STATUS.invert[:FAILED])
    logger.info "error in blogvault scraping job #{e}"
  end

end
