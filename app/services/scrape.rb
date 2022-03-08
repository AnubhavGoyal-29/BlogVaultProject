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
    MUPLUGINS = 'mu-plugins'
    THEMES = 'themes'
    JS = 'js'
    CLOUDFLARE = 'cloudflare'
  end

  def self.filter_wp_urls(urls, logger, test_id)
    url_html_version_map = Hash.new{ |h,k| h[k] = Hash.new }
    threads = []
    # _proxy = ProxyDatum.order('RANDOM()').first
    urls.each do |url_id|
      threads << Thread.new(){
        thread_block(url_id, url_html_version_map, logger, test_id)
      }
    end
    threads.each do |thread|
      thread.join
    end
    return url_html_version_map
  end

  def self.thread_block(url_id, url_html_version_map, logger, test_id)
    begin
      url = Url.find(url_id)
      html = Nokogiri::HTML.parse(RestClient.get (url.url + "?x=#{rand(999999)}"))
      #File.write("/tmp/#{url.url}", html)
      wordpress_and_version_hash = check_wordpress_in_meta(html) || Hash.new  # fetching both cms type and its version together 

      if !wordpress_and_version_hash.present? and check_wordpress_in_html(html) 
        wordpress_and_version_hash[:cms] = "wordpress"
        version_from_resource = find_wordpress_version(html) 
        wordpress_and_version_hash[:cms_version] = version_from_resource
      end

      if wordpress_and_version_hash.present?
        url.cms || url.update(:cms => wordpress_and_version_hash[:cms])
        url_html_version_map[url_id] = {:html => html, :cms_version => wordpress_and_version_hash[:cms_version]}
      end
    rescue => e
      logger.info "Test Id : #{test_id} Url: #{url.url} Error: #{e}"
    end
  end

  def self.check_wordpress_in_meta(html)
    meta_name = ['generator', 'Generator']
    meta_name.each do |name|
      html.search("meta[name='#{name}']").map do |line|
        if line['content']
          cms = line['content']
          wordpress_and_version_hash = check_wordpress_name(cms)
          return wordpress_and_version_hash if wordpress_and_version_hash
        end
      end
    end
    return nil
  end

  def self.check_wordpress_name(cms)
    if cms && ( cms['Wordpress'] || cms['wordpress'] || cms['WordPress'] )
      wordpress_and_version_arr = cms.split(' ')
      return {:cms => "wordpress", :cms_version => wordpress_and_version_arr[1]}
    end
    return nil;
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

  def self.find_version_in_sub_resource(line, sub_resource)
    checks = ['wp-includes/css/dist/block-library/style.min.css', 'wp-includes/js/wp-embed.min.js']
    if line[sub_resource]
      checks.each do |check|
        if line[sub_resource][check]
          version = line[sub_resource].split('ver=')[1]
          if version.size < 7 # version be like 5.14 or 12344232321212 so to take only actual version check is < 7
            return version
          end
        end
      end
    end
    return nil
  end

  def self.scrape_html(urls_data, logger)
    data = Hash.new{|h,k| h[k] = Hash.new }
    urls_data.each do |key, value|
      html = value[:html]
      maped_data = Hash.new
      url = Url.find(key).url 

      get_data_from_resource(url, html, Tags::LINK, DataTypes::PLUGINS, maped_data, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::PLUGINS, maped_data, logger)

      get_data_from_resource(url, html, Tags::LINK, DataTypes::MUPLUGINS, maped_data, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::MUPLUGINS, maped_data, logger)

      get_data_from_resource(url, html, Tags::LINK, DataTypes::THEMES, maped_data, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::THEMES, maped_data, logger)

      get_data_from_resource(url, html, Tags::LINK, DataTypes::JS, maped_data, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::JS, maped_data, logger)

      get_data_from_resource(url, html, Tags::LINK, DataTypes::CLOUDFLARE, maped_data, logger)
      get_data_from_resource(url, html, Tags::SCRIPT, DataTypes::CLOUDFLARE, maped_data, logger) 

      maped_data[:login_url] = get_login_url(url, logger)
      maped_data[:ip] = get_ip(url)
      data[key] = {:maped_data => maped_data, :cms_version => value[:cms_version]}
    end
    logger.info data
    return data
  end

  def self.get_data_from_resource(url, html, resource, data_type, maped_data, logger)
    resource_data = html.css(resource)
    resource_data.each do |line|
      get_data_from_sub_source(url, line, data_type, Tags::SRC, maped_data, logger)
      get_data_from_sub_source(url, line, data_type, Tags::HREF, maped_data, logger)
    end
  end

  def self.get_data_from_sub_source(url, line, data_type, sub_resource, maped_data, logger)
    if line[sub_resource] and line[sub_resource][data_type]
      return maped_data[data_type] = true if data_type == DataTypes::CLOUDFLARE

      if data_type == DataTypes::JS
        return if line[sub_resource][DataTypes::PLUGINS] || line[sub_resource][DataTypes::THEMES]
        key_words = line[sub_resource].split('/')
        key_words = key_words - [nil, '']
        key_words = remove_common_words_from_line(url, key_words, logger)
        js_and_version_arr = key_words.join('/').split('?')
        js_and_version_hash = {:js => js_and_version_arr[0], :version => js_and_version_arr[1]}
        if js_and_version_hash[:version]
          js_and_version_hash[:version] = js_and_version_hash[:version].split('=')[1] # saving only version at 2nd index of js_and_version
        end
        js_lib = js_and_version_hash[:js]
        version = js_and_version_hash[:version]
        if version&.to_i == 0  # reject all string
          version = nil
        end
        maped_data[data_type] ||= []
        maped_data[data_type] << {:js_lib => js_lib, :version => version}
        return 
      end
      #key_words stores string values spllitted by '/' sign in order to obtain resource and its next value
      key_words = line[sub_resource].split('/')   
      key_words = key_words.reverse
      data_type_index = key_words.index(data_type)
      if data_type_index && key_words[data_type_index-1] && !key_words[data_type_index-1]['.js']
        maped_data[data_type] ||= []
        maped_data[data_type] << key_words[data_type_index-1].split('?')[0]
      end
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
        return nil
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

  def self.remove_common_words_from_line(url, key_words, logger)
    common_words = ['libs', 'js', 'cache', 'min', 'lib', 'ajax', 'https:', 'wp-content', 'wp-includes','www.'+ url, url, '1']
    key_words = key_words - common_words
    return key_words
  end
end
