class TestInitializeJob < ApplicationJob
  queue_as :default
  
  def logger
    @logger ||= Logger.new("log/testing.log")
  end

  def perform(urls)
    logger.info "test has been initialized"
    urls = urls - ['']
    test = Test.create!(:number_of_urls => urls.count, :status => Test::STATUS.invert[:RUNNING])
    url_ids = []
    new_urls = []
    new_id = Url.last ? Url.last.id : 1 ; 
    urls.each_slice(100) do |_urls|
      urls_hash = Url.where(:url => _urls).pluck(:url, :id).to_h
      _urls.each do |url|
        if !urls_hash[url].present?
          new_urls << Url.new(:url => url)
          url_ids << new_id
          new_id += 1
        else
          logger.info "#{url} is present"
          url_ids << urls_hash[url]
        end
      end
    end

    Url.import new_urls

    url_ids.each_slice(10) do |_url_ids|
      step = Step.create(:status => Step::STATUS.invert[:INITIALIZED], :urls => _url_ids, :test_id => test.id)
      BlogvaultScrapingJob.perform_later(_url_ids, test.id, step.id)
    end
  rescue => e
    Test.find(test.id).update(:status => Step::STATUS.invert[:FAILED])
    logger.info "error in test initialize #{e}"
  end
end
