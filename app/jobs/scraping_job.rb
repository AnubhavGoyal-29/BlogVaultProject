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

    logger.info "Test Id: #{test.id.to_s} Step Id: #{step.id.to_s} Message: Scraping Job Started"
    step.update!(:status => V2::Step::Status::RUNNING)
    data = Scrape::filter_wp_urls(@website_ids, logger, test.id.to_s)     # here data will be maped agains url id from our database tables
    logger.info "Test Id: #{test.id.to_s} Step Id : #{step.id.to_s} Message: Filter completed"
    data = Scrape::scrape_html(data, logger)
    logger.info "Test Id: #{test.id.to_s} Step Id : #{step.id.to_s} Message: Scraping completed"
    site_data_objects = V2::SiteDataInfo.import_data(test.id.to_s, data, logger)
    TestCompletionJob.perform_now(logger, test.id.to_s, step.id.to_s)
  rescue => e
    step.update(:status => V2::Step::Status::FAILED)
    logger.info "Test Id: #{test.id.to_s} Step Id : #{step.id.to_s} File : scraping_job.rb Error: #{e}"
  end

end
