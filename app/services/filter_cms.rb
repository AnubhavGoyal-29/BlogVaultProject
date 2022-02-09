class FilterCms
  def initialize(urls)
    puts 'hi i am filter cms'
    @urls = urls
  end
  def start_filter
    urls = []
    data  = []
    @urls.each do |row|
      begin
        puts row
        html = Nokogiri::HTML.parse( RestClient.get row)
        found = false
        html.search("meta[name='generator']").map { |n|
          cms = n['content']
          if( cms['ord'] and cms['ress'])
            puts 'found'
            urls << row
            data << html
            found = true
            break;
          end
        }
        if(found)
          next
        else
          links = html.css('link')
          links.map do |link|
            if(link['href']['wp-content'])
              urls << row
              data << html
              break
            end
          end
        end
      rescue => e
      end
    end
    puts urls
    return [urls,data]
  end

end
