class TestCompleteConfirmationJob < ApplicationJob
  queue_as :default

  def logger
    @logger ||= Logger.new("log/testing.log")
  end 

  def perform(test_id)
    while true
      if Resque.info[:working] == 1
        test = Test.find(test_id)
        test.status = 1
        test.save!
        puts "test successfully updated, url update started"
        Url.url_site_data_info_update(test_id, logger)
        break
      else
        puts "Remaining jobs are #{Resque.info[:working]}"
      end
      sleep(1)
    end
  end
end
