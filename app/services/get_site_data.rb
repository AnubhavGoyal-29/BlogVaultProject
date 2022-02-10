class GetSiteData
  def initialize(data)
    puts 'i am get site data'
    @data = data
  end
  def start_scrape
    data = []
    puts @data.size
    puts @data[1].size
    for i in 0..@data[1].size-1 do
      html =@data[1][i]
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
=begin
      print "data for ",@data[0][i]
      puts
      data = barr.each { |key,arr|
        puts key
        puts arr.uniq
        puts
      }
=end  
      barr = barr.each { |key,arr|
        key
        arr.uniq
      }
      data << [@data[0][i],barr]
    end
    return data
  end
end
