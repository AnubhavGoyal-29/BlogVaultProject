class BlogvaultScrapingJob < ApplicationJob
  @queue = :my_worker_queue
  def perform(urls,testNo)
    BlogvaultScrape.new(urls,testNo)
  end
end
