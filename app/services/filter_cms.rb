class FilterCms
  @version = "" # to store version of a url
  class << self

    def filter_wp_urls(urls,logger)
      url_html_version_map = Hash.new{ |h,k| h[k] = Hash.new }
      threads = []
      urls.each do |url|
        threads <<  Thread.new() {
          thread_block(url)
        }
        threads.each do |thread|
          thread.join
        end
      end
      return url_html_version_map
    end

    def thread_block(url)
      begin
        html = Nokogiri::HTML.parse(RestClient.get url)
        _url = Url.where(url: url).first
        if(_url)
          _url_id = _url.id
          url_html_version_map[_url_id] = {:html => html, :version => _url.version}
        else
          if check_wordpress_in_meta(html)
            _url_id =  Url.import_url(url)
            url_html_version_map[_url_id] = {:html => html, :version => @version}
          end
        end
      rescue => e
        puts "#{url}...#{e}"
      end
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

    def scrape_html(urls_data)
      logger.info "HTML_SCRAPING_IS_STARTED_FROM_GET_SITE_DATA"
      data = Hash.new{|h,k| h[k] = [] }
      urls_data.each do |key, value|
        logger.info key
        html = value['html']
        mapedData = Hash.new{|h,k| h[k] = [] }
        get_data_from_resource(html, 'script', 'plugins', mapedData)
        get_data_from_resource(html, 'script', 'themes', mapedData)
        get_data_from_resource(html, 'script', 'js', mapedData)
        get_data_from_resource(html, 'link', 'js', mapedData)
        get_data_from_resource(html, 'link', 'cloudflare', mapedData)
        get_data_from_resource(html, 'script', 'cloudflare', mapedData)
        data[key] = [mapedData, value['version']]
      end
      logger.info data
      return data
    end

    def get_data_from_resource(html, resource, dataType, mapedData)
      resource_data = html.css(resource)
      resource_data.each do |line|
        get_data_from_sub_source(line, dataType, 'src', mapedData)
        get_data_from_sub_source(line, dataType, 'href', mapedData)
      end
    end

    def get_data_from_sub_source(line, dataType, subResource, mapedData)
      if line[subResource] and line[subResource][dataType]
        return mapedData[dataType] = [1] if dataType == 'cloudflare'
        tempArr = line[subResource].split('/')      #tempArr stores string values spllitted by '/' sign in order to obtain resource and its next value
        tempArr = tempArr.reverse
        dataTypeIndex = tempArr.index(dataType)
        mapedData[dataType].push(tempArr[dataTypeIndex-1]) if dataTypeIndex and tempArr[dataTypeIndex-1]
      end
    end
  end
end
