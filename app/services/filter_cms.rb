class FilterCms
  @version = "" # to store version of a url
  class << self

    def logger
      @logger ||= Logger.new("log/testing.log")
    end

    def start_filter_wordpress_sites(urls_data)
      logger.info "START_FILTER_WP_WORDPRESS_SITES_IS_CALLED_FROM_FILTER_CMS"
      url_html_version_map = Hash.new{|h, k| h[k] = [] }
      urls_data.each do |url|
        begin
          html = Nokogiri::HTML.parse(RestClient.get url)
          if check_wordpress_in_meta(html)
            url_html_version_map[url] = [html, @version]
          end
        rescue => e
          puts e
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
