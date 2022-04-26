class TestInitializeJob < ApplicationJob
  queue_as = :default


  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def test
    @test ||= V2::Test.find(@test_id)
  end

  def perform(urls, test_id)
    @urls = urls - ['', nil]
    @test_id = test_id
    logger.info "Test Id: #{test_id} Message: started test_intitialize_job"
    test.update(:status => V2::Test::Status::RUNNING, :started_at => Time.now)
    website_ids = []
    new_websites = []
    @urls.each_slice(1024) do |_urls|
      urls_hash = V2::Website.in(:url => _urls).pluck(:url, :id).to_h
      _urls.each do |url|
        if !urls_hash[url].present?
          new_websites << {:url => url, :first_test => test.id.to_s}
          logger.info "Test Id: #{test.id.to_s} Url: #{url} Message: Created"
        else
          logger.info "Test Id: #{test.id.to_s} Url: #{url} Message: Present"
          website_ids << urls_hash[url].to_s
        end
      end
    end
    V2::Website.create(new_websites)
    website_ids += V2::Website.where(:first_test => test.id.to_s).pluck(:id).map(&:to_s)
    website_ids.each_slice(10) do |_website_ids|
      step = V2::Step.create!(:status => V2::Step::Status::INITIALIZED, :website_ids => _website_ids, :test => test)
      ScrapingJob.perform_later(_website_ids, test.id.to_s, step.id.to_s)
    end
    logger.info "Test Id: #{test.id.to_s} Message: completed test_intitialize_job"
    rescue => e
    test.update(:status => V2::Test::Status::FAILED)
    logger.info "Test Id: #{test.id.to_s} Error: #{e.message} Backtrace : #{e.backtrace}"
  end

end
