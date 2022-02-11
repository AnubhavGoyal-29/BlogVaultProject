class FilterCms
  def initialize(urls)
    puts 'hi i am filter cms'
    @urls = urls
  end
  def start_filter
    urls = []
    data  = []
    cms_a = []
    @urls.each do |row|
        begin
          puts row
          html = Nokogiri::HTML.parse( RestClient.get row)
          found = false
          html.search("meta[name='generator']").map { |n|
            cms = n['content']
            if( cms['ord'] and cms['ress'])
              urls << row
              data << html
              found = true
              cms_a << cms.split(' ')
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
                cms_a << [cms.split(' ')]
                break
              end
            end
          end
        rescue => e
        end
    end
    return [urls,data,cms_a]
  end

end
