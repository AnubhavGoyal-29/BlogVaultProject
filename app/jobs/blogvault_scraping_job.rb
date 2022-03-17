class BlogvaultScrapingJob < ApplicationJob
  queue_as = :default

  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def test
    @test ||= Test.find(@test_id)
  end

  def step
    @step ||= Step.find(@step_id)
  end

  def perform(url_ids, test_id, step_id)

    @url_ids = url_ids
    @test_id = test_id
    @step_id = step_id

    logger.info "Test Id: #{test.id} Blogvault Scraping Job : #{step.id} Message: Started"
    step.update(:status => Step::Status::RUNNING)
    data = Scrape::filter_wp_urls(@url_ids, logger, test.id)     # here data will be maped agains url id from our database tables
    logger.info "Test Id: #{test.id} Step Id : #{step.id} Message: Filter completed"
    data = Scrape::scrape_html(data, logger)
    logger.info "Test Id: #{test.id} Step Id : #{step.id} Message: Scraping completed"
    site_data_objects = SiteDataInfo.import_data(test.id, data, logger)
    logger.info "Test Id: #{test.id} Step Id : #{step.id} Message: Url update started"
    TestCompletionJob.perform_now(logger, test.id, step.id)
  rescue => e
    step.update(:status => Step::Status::FAILED)
    logger.info "Test Id: #{test.id} Step Id : #{step.id} Error: #{e}"
  end

end
