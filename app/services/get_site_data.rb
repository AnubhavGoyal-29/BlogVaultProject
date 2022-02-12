class GetSiteData
  class<<self
    def start_scraping_html(urls_data)
      data = []
      for i in 0..urls_data[1].size-1 do
        html =urls_data[1][i]
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
        data << [urls_data[0][i],barr,urls_data[2][i]]
      end
      return data
    end
  end
end
