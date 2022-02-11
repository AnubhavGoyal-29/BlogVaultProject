class GetSiteData
  def initialize(data)
    puts 'i am get site data'
    @data = data
  end
  def start_scrape
    data = []
    puts @data.size
    puts @data[1].size
    puts @data[2].size
    for i in 0..@data[1].size-1 do
      html =@data[1][i]
      scripts = html.css('script')
      barr = Hash.new{|h,k| h[k] = [] }
      scripts.each do |script|
        if script['src'] and script['src']['wp-content']
          arr = script['src'].split('/')
          arr = arr.reverse
          j = arr.index('wp-content')
          if arr[j-2]
             barr[arr[j-1]].push(arr[j-2])
          end
        end
      end 
      puts barr
      data << [@data[0][i],barr,@data[2][i]]
    end
    return data
  end
end
