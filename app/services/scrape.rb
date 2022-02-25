class Scrape

  require'resolv'
 # require 'selenium-webdriver'

  module Tags
    SCRIPT = 'script'
    LINK = 'link'
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

      if !_version and check_wordpress_in_html(html) 
        version_from_resource = find_wordpress_version(html) 
        _version = version_from_resource ? version_from_resource : 'version not found'
      end
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

  def self.check_wordpress_in_html(html)
    if html.inner_text.match(/wp-content/)
      return true
    end
  end

  def self.find_wordpress_version(html)
    return find_version_in_resource(Tags::LINK, html) || find_version_in_resource(Tags::SCRIPT, html)
  end

  def self.find_version_in_resource(resource, html)
    lines = html.css(resource)
    lines.each do |line|
      version = find_version_in_sub_resource(line, Tags::SRC) || find_version_in_sub_resource(line, Tags::HREF)
      return version if version 
    end
    return nil
  end

  def self.find_version_in_sub_resource(line, subresource)
    checks = ['wp-includes/css/dist/block-library/style.min.css', 'wp-includes/js/wp-embed.min.js']
    if line[subresource]
      checks.each do |check|
        if line[subresource][check]
          ver = line[subresource].split('ver=')[1]
          if ver.size < 7
            puts ver
            return ver
          end
        end
      end
    end
    return nil
  end
  
  def self.check_wordpress_name(cms)
    if cms && cms['Wordpress'] || cms['wordpress'] || cms['WordPress']
      wordpressAndVersion = cms.split(' ')
      return wordpressAndVersion[1] ? wordpressAndVersion[1] : 'version not found'
    end
    return nil;
  end

  def self.scrape_html(urls_data, logger)
    data = Hash.new{|h,k| h[k] = Hash.new }
    urls_data.each do |key, value|
      html = value[:html]
      mapedData = Hash.new{|h,k| h[k] = [] }
      url = Url.find(key).url
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::PLUGINS, mapedData, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::THEMES, mapedData, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::JS, mapedData, logger)
      get_data_from_resource(url, html, Tags::LINK, DataTypes::JS, mapedData, logger)
      get_data_from_resource(url, html, Tags::LINK, DataTypes::CLOUDFLARE, mapedData, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::CLOUDFLARE, mapedData, logger) 
      mapedData[:login_url].push(get_login_url(url, logger))
      mapedData[:ip].push(get_ip(url))
      data[key] = {:mapedData => mapedData, :version => value[:version]}
    end
    return data
  end

  def self.get_data_from_resource(url, html, resource, dataType, mapedData, logger)
    resource_data = html.css(resource)
    resource_data.each do |line|
      get_data_from_sub_source(url, line, dataType, Tags::SRC, mapedData, logger)
      get_data_from_sub_source(url, line, dataType, Tags::HREF, mapedData, logger)
    end
  end

  def self.get_data_from_sub_source(url, line, dataType, subResource, mapedData, logger)
    if line[subResource] and line[subResource][dataType]
      return mapedData[dataType] = [1] if dataType == DataTypes::CLOUDFLARE

      if dataType == DataTypes::JS
        return if line[subResource][DataTypes::PLUGINS] || line[subResource][DataTypes::THEMES]
        tempArr = line[subResource].split('/')
        tempArr = tempArr - [nil, '']
        tempArr = remove_common_words_from_line(url, tempArr, logger)
        arr = tempArr.join('/').split('?')
        if arr[1]
          arr[1] = arr[1].split('=')[1]
        end
        version = ''
        js = arr[0] ;
        version = arr[1] if arr[1]
        if version.to_i == 0
          version = '0'
        end
        mapedData[dataType].push([js,version])
        return 
      end
      tempArr = line[subResource].split('/')      #tempArr stores string values spllitted by '/' sign in order to obtain resource and its next value
      tempArr = tempArr.reverse
      dataTypeIndex = tempArr.index(dataType)
      mapedData[dataType].push(tempArr[dataTypeIndex-1].split('?')[0]) if dataTypeIndex && tempArr[dataTypeIndex-1] && !tempArr[dataTypeIndex-1]['.js']
    end
  end

  def self.get_login_url(url, logger)
    login_suffix = ['/login', '/wp-admin', '/wp-config']
    login_suffix.each do |suffix|
      _url = url + suffix
      begin
        res = RestClient.get _url
        return _url if res.code == 200
      rescue => e
        return '0'
      end
    end
    return nil
  end

  def self.get_ip(url)
    ip =  Resolv.getaddress url
    return ip  
  end

=begin
  def self.get_host_name(url)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.navigate.to "https://check-host.net/?lang=en" 
    driver.find_element(:id, 'hostip').send_keys url
    driver.find_element(:name, 'info').click
    host_info = driver.find_element(:class => "hostinfo")
    isp = host_info.text.split("\n")[3].split(" ")[1].split(",")[0]
    return isp
  end
=end

  def self.remove_common_words_from_line(url, tempArr, logger)
    common_words = ['libs', 'js', 'cache', 'min', 'lib', 'ajax', 'https:', 'wp-content', 'wp-includes','www.'+ url, '1']
    tempArr = tempArr - common_words
    return tempArr
  end
end
