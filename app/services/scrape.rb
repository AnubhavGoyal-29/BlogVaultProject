require 'nokogiri'
require 'rest-client'
require 'csv'
class Scrape
  def initialize
    start_scrape
  end

  def start_scrape
    urls = []
    CSV.foreach('top10milliondomains.csv',headers: false) do |row|
      begin
        puts row[0]
        html = Nokogiri::HTML.parse( RestClient.get row[0] )
        if(html.at('meta[name="generator"]'))
          cm_s = html.at('meta[name="generator"]')['content']
          if(cm_s['ord'] and cm_s['ress'])
            Url.create(url:row[0],test_id:nil)
          end
        elsif(html.at('meta[name="Generator"]'))
          cm_s = html.at('meta[name="Generator"]')['content']
          if(cm_s['ord'] and cm_s['ress'])
            Url.create(url:row[0],test_id:nil)
          end
        else 
          links = html.css('link')
          links.map do |link|
            if(link['href']['wp-content'])
              Url.create(url:row[0],test_id:nil)
              break
            end
          end
        end
        puts "checked #{row[0]}"
      rescue => e
        puts "some error occuured in #{row[0]}"
      end
    end
  end
end
