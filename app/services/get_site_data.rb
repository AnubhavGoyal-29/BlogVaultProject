class GetSiteData
  def initialize(data)
    puts 'i am get site data'
    @data = data
  end
  def start_scrape
    puts @data[1].size
    for i in @data[1] do
      html = i
      plugins = html.css('script')
      barr = Hash.new{|h,k| h[k] = [] }
      plugins.each do |plugin|
        if plugin['src']
          arr = plugin['src'].split('/')
          if arr[5]
             barr[arr[4]].push(arr[5])
          end
        end
      end
      data = barr.each { |key,arr|
        puts key
        puts arr.uniq
        puts 
      }
=begin
      barr = barr.uniq
      barr.sort_by{|a,b| a[0] <=> b[0]}
      barr.each { |arr|
        print arr[0],"   ",arr[1]
        puts
      }
=end
    end
  end
end
