class TestInitializeJob < ApplicationJob
  queue_as = :default

  logger.info "Test Id: #{test.id} Message: started test_intitialize_job"

  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def test
    @test ||= Test.find(@test_id)
  end

  def perform(urls, test_id)

    @urls = urls
    @test_id = test_id

    @urls = @urls - ['']
    test.update(:status => Test::Status::RUNNING, :started_at => Time.now)
    url_ids = []
    new_urls = []
    @urls.each_slice(500) do |_urls|
      urls_hash = Url.where(:url => _urls).pluck(:url, :id).to_h
      _urls.each do |url|
        if !urls_hash[url].present?
          new_urls << Url.new(:url => url, :first_seen => test.id)
        else
          logger.info "Test Id: #{test.id} Url: #{url} Message: Present"
          url_ids << urls_hash[url]
        end
      end
    end
    Url.import new_urls
    url_ids += Url.where(:url => new_urls.pluck(:url)).pluck(:id)
    url_ids.each_slice(10) do |_url_ids|
      step = Step.create!(:status => Step::Status::INITIALIZED, :urls => _url_ids, :test_id => test.id)
      ScrapingJob.perform_later(_url_ids, test.id, step.id)
    end
    logger.info "Test Id: #{test.id} Message: completed test_intitialize_job"
  rescue => e
    test.update(:status => Step::Status::FAILED)
    logger.info "Test Id: #{test.id} Error: #{e}"
  end

end
