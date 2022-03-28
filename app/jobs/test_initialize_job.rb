class TestInitializeJob < ApplicationJob
  queue_as = :default


  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def test
    @test ||= V2::Test.find(@test_id)
  end

  def perform(urls, test_id)
    logger.info "Test Id: #{test_id} Message: started test_intitialize_job"
    @urls = urls
    @test_id = test_id
    @urls = @urls - ['']
    test.update(:status => V2::Test::Status::RUNNING, :started_at => Time.now)
    website_ids = []
    new_urls = []
    @urls.each_slice(1024) do |_urls|
      urls_hash = V2::Website.where(:url => _urls).pluck(:url, :id).to_h
      _urls.each do |url|
        if !urls_hash[url].present?
          new_urls << V2::Website.new(:url => url, :first_test => test.id)
          logger.info "Test Id: #{test.id} Url: #{url} Message: Created"
        else
          logger.info "Test Id: #{test.id} Url: #{url} Message: Present"
          website_ids << urls_hash[url]
        end
      end
    end
    V2::Website.import new_urls
    website_ids += V2::Website.where(:first_test => test.id).pluck(:id)
    website_ids.each_slice(10) do |_website_ids|
      step = V2::Step.create!(:status => V2::Step::Status::INITIALIZED, :urls => _website_ids, :test_id => test.id)
      ScrapingJob.perform_later(_website_ids, test.id, step.id)
    end
    logger.info "Test Id: #{test.id} Message: completed test_intitialize_job"
  rescue => e
    test.update(:status => V2::Test::Status::FAILED)
    logger.info "Test Id: #{test.id} Error: #{e}"
  end

end
