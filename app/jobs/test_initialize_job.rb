class TestInitializeJob < ApplicationJob

  def initialize(urls, test_id)
    @urls = urls
    @test_id = test_id
  end

  queue_as :default
  
  def logger
    @logger ||= Logger.new("log/testing.log")
  end
  def test
    @test ||= Test.find(@test_id)
  end
  def perform
    logger.info "test has been initialized"
    @urls = @urls - ['']
    test.update(:status => Test::Status::RUNNING)
    url_ids = []
    new_urls = []
    @urls.each_slice(100) do |_urls|
      urls_hash = Url.where(:url => _urls).pluck(:url, :id).to_h
      _urls.each do |url|
        if !urls_hash[url].present?
          new_urls << Url.new(:url => url, :first_seen => test.id)
        else
          logger.info "#{url} is present"
          url_ids << urls_hash[url]
        end
      end
    end
    Url.import new_urls
    url_ids << Url.where(:first_seen => test.id).pluck(:id)
    url_ids.each_slice(10) do |_url_ids|
      step = Step.create!(:status => Step::Status::INITIALIZED, :urls => _url_ids, :test_id => test.id)
      BlogvaultScrapingJob.perform_later(_url_ids, test.id, step.id)
    end
  rescue => e
    test.update(:status => Step::Status::FAILED)
    logger.info "error in test initialize #{e}"
  end
end
