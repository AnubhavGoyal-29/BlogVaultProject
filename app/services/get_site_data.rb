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
      puts "running for url #{@data[0][i]}"
      html =@data[1][i]
      scripts = html.css('script')
      barr = Hash.new{|h,k| h[k] = [] }
      scripts.each do |script|
        if script['src']
          if script['src']['wp-content']
            arr = script['src'].split('/')
            arr = arr.reverse()
            i = arr.find_index('wp-content')
            word = arr[i-1]
            value = arr[i-2]
            barr[arr[i-1]].push(arr[i-2])
          end
        end
      end
      n_arr = barr.each { |key,arr|
        key
        arr.uniq
      }
      data << [@data[0][i],n_arr,@data[2][i]]
    end
    return data
  end
end
