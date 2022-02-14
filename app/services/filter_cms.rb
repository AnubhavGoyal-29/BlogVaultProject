class FilterCms
  @version = "" # to store version of a url
  class << self

    def start_filter_wordpress_sites(urls_data)
      url_html_version_map = Hash.new{ |h,k| h[k] = [] }
      multi_threads = []
      urls_data.each do |url|
        multi_threads <<  Thread.new() {
          begin
            html = Nokogiri::HTML.parse(RestClient.get url)
            if check_wordpress_in_meta(html)
              url_html_version_map[url] = [html, @version]
              puts url
            end
          rescue => e
            puts "#{url}...#{e}"
          end
        }
        multi_threads.each do |thread|
          thread.join
        end
      end
      return url_html_version_map
    end

    def check_wordpress_in_meta(html)
      metaName = ['generator', 'Generator']
      metaName.each do |name|
        html.search("meta[name='#{name}']").map do |line|
          if line['content']
            cms = line['content']
            return true if check_wordpress_name(cms)
          end
        end
      end
      return false
    end

    def check_wordpress_name(cms)
      if cms && cms['Wordpress'] || cms['wordpress'] || cms['WordPress']
        wordpressAndVersion = cms.split(' ')
        @version = wordpressAndVersion[1] ? wordpressAndVersion[1] : "version not found"
        return true
      end
      return false;
    end
  end
end
