require 'nokogiri'
require 'rest-client'
class GetSiteInfo
  
  def scrape(url)
    html = Nokogiri::HTML.parse( RestClient.get url)
    links = html.css('link')
    puts links.count
    scripts = html.css('script')
    puts scripts.count
    wordpress_links = []
    links.map do |link|
      if link['wordpress']
        puts link
        wordpress_links.append(link)
      end
    end
    scripts.map do |script|
      if script['wordpress']
        puts script
        wordpress_links.append(script)
      end
    end
    puts wordpress_links
  end
end
