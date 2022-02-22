class Scrape

  module Tags
    SCRIPT = 'script'
    LINK = 'links'
    SRC = 'src'
    HREF = 'href'
  end

  module DataTypes
    PLUGINS = 'plugins'
    THEMES = 'themes'
    JS = 'js'
    CLOUDFLARE = 'cloudflare'
  end
  def self.filter_wp_urls(urls, logger)
    url_html_version_map = Hash.new{ |h,k| h[k] = Hash.new }
    threads = []
    # _proxy = ProxyDatum.order('RANDOM()').first
    urls.each do |url_id|
      threads << Thread.new(){
        thread_block(url_id,url_html_version_map, logger)
      }
    end
    threads.each do |thread|
      thread.join
    end
    return url_html_version_map
  end

  def self.thread_block(url_id, url_html_version_map, logger)
    begin
      # puts url + "    " + proxy_ip
      # RestClient.proxy = "http://" + proxy_ip
      url = Url.find(url_id).url
      html = Nokogiri::HTML.parse(RestClient.get url)
      _version = check_wordpress_in_meta(html)
      _version ||= check_wordpress_in_source(html) ? 'Version not found' : nil
      if _version
        _url_id = url_id
        url_html_version_map[_url_id] = {:html => html, :version => _version}

      end
    rescue => e
      logger.info "#{url}...#{e}"
    end
  end

  def self.check_wordpress_in_meta(html)
    metaName = ['generator', 'Generator']
    metaName.each do |name|
      html.search("meta[name='#{name}']").map do |line|
        if line['content']
          cms = line['content']
          version = check_wordpress_name(cms)
          return version if version
        end
      end
    end
    return false
  end

  def self.check_wordpress_in_source(html)
    if html.inner_text.match(/wp-content/)
      return true;
    end
  end

  def self.check_wordpress_name(cms)
    if cms && cms['Wordpress'] || cms['wordpress'] || cms['WordPress']
      wordpressAndVersion = cms.split(' ')
      return wordpressAndVersion[1] ? wordpressAndVersion[1] : "version not found"
    end
    return nil;
  end

  def self.scrape_html(urls_data, logger)
    data = Hash.new{|h,k| h[k] = Hash.new }
    urls_data.each do |key, value|
      html = value[:html]
      mapedData = Hash.new{|h,k| h[k] = [] }
      get_data_from_resource(html, Tags::SCRIPT, DataTypes::PLUGINS, mapedData)
      get_data_from_resource(html, Tags::SCRIPT, DataTypes::THEMES, mapedData)
      get_data_from_resource(html, Tags::SCRIPT, DataTypes::JS, mapedData)
      get_data_from_resource(html, Tags::LINK, DataTypes::JS, mapedData)
      get_data_from_resource(html, Tags::LINK, DataTypes::CLOUDFLARE, mapedData)
      get_data_from_resource(html, Tags::SCRIPT, DataTypes::CLOUDFLARE, mapedData)
      mapedData[:login_url] = get_login_url(url)
      data[key] = {:mapedData => mapedData, :version => value[:version]}
    end
    return data
  end

  def self.get_data_from_resource(html, resource, dataType, mapedData)
    resource_data = html.css(resource)
    resource_data.each do |line|
      get_data_from_sub_source(line, dataType, Tags::SRC, mapedData)
      get_data_from_sub_source(line, dataType, Tags::HREF, mapedData)
    end
  end

  def self.get_data_from_sub_source(line, dataType, subResource, mapedData)
    if line[subResource] and line[subResource][dataType]
      return mapedData[dataType] = [1] if dataType == 'cloudflare'
      tempArr = line[subResource].split('/')      #tempArr stores string values spllitted by '/' sign in order to obtain resource and its next value
      tempArr = tempArr.reverse
      dataTypeIndex = tempArr.index(dataType)
      mapedData[dataType].push(tempArr[dataTypeIndex-1].split('?')[0]) if dataTypeIndex and tempArr[dataTypeIndex-1]
    end
  end

  def self.get_login_url(url)
    login_suffix = ['/login', '/wp-admin', '/wp-config']
    login_suffix.each do |suffix|
      _url = url + suffix
      res = RestClient.get _url
      return _url if res.code == 200
    end
    return nil
  end
end
