class Scrape

  require'resolv'

  module Tags
    SCRIPT = 'script'
    LINK = 'link'
  end

  module SubSource
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

  def self.filter_wp_urls(website_ids, logger, test_id)
    url_html_version_map = Hash.new{ |h,k| h[k] = Hash.new }
    threads = []
    # _proxy = ProxyDatum.order('RANDOM()').first
    V2::Website.in(:id => website_ids).each do |website|
      threads << Thread.new(){
        thread_block(website, url_html_version_map, logger, test_id)
      }
    end
    threads.each do |thread|
      thread.join
    end
    return url_html_version_map
  end

  def self.thread_block(website, url_html_version_map, logger, test_id)
    begin
      html = Nokogiri::HTML.parse(RestClient.get (website.url + "?x=#{rand(999999)}"))
      cms_and_version_hash = cms_and_version(html)
      if cms_and_version_hash.present?         # fetching both cms type and its version together 
        website.cms || website.update(:cms => cms_and_version_hash[:cms])
        url_html_version_map[website.id] = {:html => html, :cms_version => cms_and_version_hash[:cms_version]}
      end
    rescue => e
      logger.info "Test Id : #{test_id.to_s} Url: #{website.url} Error: #{e}"
    end
  end

  def self.cms_and_version(html)
    check_is_wordpress(html) || check_is_drupal(html) || check_is_shopify(html) || check_is_joomla(html)
  end

  def self.check_is_wordpress(html)
    return check_wordpress_in_meta(html) || check_wordpress_in_html(html)
  end

  def self.check_is_drupal(html)
    # some code here
    return nil
  end

  def self.check_is_shopify(html)
    # some code here
    return nil
  end

  def self.check_is_joomla(html)
    # some code here
    return nil
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
    return nil
  end

  def self.check_wordpress_in_html(html)
    find_wordpress_from_version(html)
  end

  def self.find_wordpress_from_version(html)
    return find_version_in_resource(Tags::LINK, html) || find_version_in_resource(Tags::SCRIPT, html)
  end

  def self.find_version_in_resource(resource, html)
    lines = html.css(resource)
    lines.each do |line|
      version = find_version_in_sub_resource(line, SubSource::SRC) || find_version_in_sub_resource(line, SubSource::HREF)
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
          if version.size < 9 # version be like 5.14 or 12344232321212 so to take only actual version check is < 7
            return {:cms => "wordpress", :cms_version => version}
          end
        end
      end
    end
    return nil
  end

  def self.scrape_html(urls_data, logger)
    data = {}
    urls_data.each do |key, value|
      html = value[:html]
      maped_data = Hash.new
      url = V2::Website.find(key).url 
      DataTypes.constants.each do |data_type|
        Tags.constants.each do |tag|
          get_data_from_resource(url, html, Tags.class_eval(tag.to_s), DataTypes.class_eval(data_type.to_s), maped_data, logger)
        end
      end
      maped_data[:login_url] = get_login_url(url, logger)
      maped_data[:ip] = get_ip(url)
      data[key] = {:maped_data => maped_data, :cms_version => value[:cms_version]}
    end
    return data
  end

  def self.get_data_from_resource(url, html, resource, data_type, maped_data, logger)
    resource_data = html.css(resource)
    resource_data.each do |line|
      SubSource.constants.each do |sub_source|
        get_data_from_sub_source(url, line, data_type, SubSource.class_eval(sub_source.to_s), maped_data, logger)
      end
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
        if version&.to_i == 0  # accept like '5.4.2' , '452' , not like 'abh122' , 'a@$#'
          version = nil
        end
        maped_data[data_type] ||= []
        maped_data[data_type] << {:js_lib => js_lib, :version => version}
        return 
      end
      #key_words stores string values spllitted by '/' sign in order to obtain resource and its next value
      key_words = line[sub_resource].split('/')
      key_words.reverse!
      data_type_index = key_words.index(data_type)
      if data_type_index && key_words[data_type_index - 1] && !key_words[data_type_index - 1]['.js']
        maped_data[data_type] ||= []
        maped_data[data_type] << key_words[data_type_index - 1].split('?')[0]
      end
    end
  end

  def self.get_login_url(url, logger)
    login_suffix = ['/login']
    login_suffix.each do |suffix|
      _url = url + suffix
      begin
        res = RestClient.get _url
        return _url if res.code == 200
      rescue => e
        logger.info "url : #{url} message : #{e}"
      end
    end
    return nil
  end

  def self.get_ip(url)
    ip =  Resolv.getaddress url
    return ip  
  end

  def self.remove_common_words_from_line(url, key_words, logger)
    common_words = ['libs', 'js', 'cache', 'min', 'lib', 'https:', 'wp-content', 'wp-includes', 'www.'+ url, url, '1']
    key_words = key_words - common_words
    return key_words
  end
end
