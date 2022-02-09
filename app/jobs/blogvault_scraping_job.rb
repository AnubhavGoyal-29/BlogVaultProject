class BlogvaultScrapingJob < ApplicationJob
  @queue = :my_worker_queue
  def perform(urls)
    BlogvaultScrape.new(urls)
  end
end
