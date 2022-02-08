require 'nokogiri'
require 'rest-client'
require 'csv'
class Scrape
  def initialize(sites)
    start_scrape(sites)
  end

  def start_scrape(sites)
    urls = []
    sites.each do |row|
      begin
        html = Nokogiri::HTML.parse( RestClient.get row)
        if(html.at('meta[name="generator"]'))
          cm_s = html.at('meta[name="generator"]')['content']
          if(cm_s['ord'] and cm_s['ress'])
            Url.create(url:row,test_id:nil)
          end
        elsif(html.at('meta[name="Generator"]'))
          cm_s = html.at('meta[name="Generator"]')['content']
          if(cm_s['ord'] and cm_s['ress'])
            Url.create(url:row,test_id:nil)
          end
        else 
          links = html.css('link')
          links.map do |link|
            if(link['href']['wp-content'])
              Url.create(url:row,test_id:nil)
              break
            end
          end
        end
        puts "checked #{row}"
      rescue => e
        puts e
        puts "some error occuured in #{row}"
      end
    end
  end
end
