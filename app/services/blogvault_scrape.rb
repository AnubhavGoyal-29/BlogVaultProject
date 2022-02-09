class BlogvaultScrape
  def initialize(urls)
    @urls = urls
    puts "hi i am blogvaultscrape"
    bla = filter_cms
    puts bla
  end
  
  def filter_cms
   return FilterCms.new(@urls)
  end

end
