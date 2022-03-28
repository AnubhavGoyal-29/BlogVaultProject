class ScrapingJob < ApplicationJob
  queue_as = :default

  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def test
    @test ||= V2::Test.find(@test_id)
  end

  def step
    @step ||= V2::Step.find(@step_id)
  end

  def perform(website_ids, test_id, step_id)

    @website_ids = website_ids
    @test_id = test_id
    @step_id = step_id

    logger.info "Test Id: #{test.id} Step Id: #{step.id} Message: Scraping Job Started"
    step.update!(:status => V2::Step::Status::RUNNING)
    data = Scrape::filter_wp_urls(@website_ids, logger, test.id)     # here data will be maped agains url id from our database tables
    logger.info "Test Id: #{test.id} Step Id : #{step.id} Message: Filter completed"
    data = Scrape::scrape_html(data, logger)
    logger.info "Test Id: #{test.id} Step Id : #{step.id} Message: Scraping completed"
    site_data_objects = V2::SiteDataInfo.import_data(test.id, data, logger)
    TestCompletionJob.perform_now(logger, test.id, step.id)
  rescue => e
    step.update(:status => V2::Step::Status::FAILED)
    logger.info "Test Id: #{test.id} Step Id : #{step.id} Error: #{e}"
  end

end
