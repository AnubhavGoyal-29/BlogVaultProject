class BlogvaultScrapingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    puts 'yo bro something is done with jobs'
  end
end
