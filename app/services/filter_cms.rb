class FilterCms
  @version = [] # to save wordpress version
  class << self

    # will return sites with cms wordpress 
    #their html and wordpress version 
    def start_filter_wordpress_sites(urls_data)
      urls = [] # to save urls
      htmls = [] # to save html of url
      urls_data.each do |url|
        begin
          html = Nokogiri::HTML.parse( RestClient.get url)
          if find_wordpress_from_meta_or_Meta(html)
            urls << url
            htmls << html
          else
          end
        rescue => e
        end
      end
      return [urls, htmls, @version]
    end
    
    # find wordpress from meta or Meta name
    def find_wordpress_from_meta_or_Meta(html)
      # checking from meta name generator
      html.search("meta[name='generator']").map do |line|
        if line['content']
          cms = line['content']
          if check_wordpress_name(cms)
            return true
          end
        end
      end
      # checking from meta name Generator
      html.search("meta[name='Generator']").map do |line|
        if line['content']
          cms = line['content']
          if check_wordpress_name(cms)
            return true
          end
        end
      end
      return false
    end

    # to check different naming of wordpress
    def check_wordpress_name(cms)
      if cms && cms['Wordpress'] || cms['wordpress'] || cms['WordPress']
        wordpressAndVersion = cms.split(' ')
        if wordpressAndVersion[1]
          @version << wordpressAndVersion[1]
        else
          @version << "version not found"
        end
        return true
      end
      return false;
    end
  end
end
