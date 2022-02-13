class GetSiteData
  class<<self
    def start_scraping_html(urls_data)
      data = Hash.new{|h,k| h[k] = [] }
      urls_data.each do |key,value|
        puts key
        html = value[0]
        mapedData = Hash.new{|h,k| h[k] = [] }
        get_data_from_resource(html,'script','plugins',mapedData)
        get_data_from_resource(html,'script','themes',mapedData)
        get_data_from_resource(html,'script','js',mapedData)
        get_data_from_resource(html,'link','js',mapedData)
        data[key] = [mapedData, value[1]]
      end
      return data
    end



    def get_data_from_resource(html,resource,dataType,mapedData)
      resource_data = html.css(resource)
      resource_data.each do |line|
        get_data_from_sub_source(line,dataType,'src',mapedData)
        get_data_from_sub_source(line,dataType,'href',mapedData)
      end
    end

    def get_data_from_sub_source(line,dataType,subResource,mapedData)
      if line[subResource] and line[subResource][dataType]
        tempArr = line[subResource].split('/')          #tempArr stores string values spllitted by '/' sign in order to obtain resource and its next value
        tempArr = tempArr.reverse
        dataTypeIndex = tempArr.index(dataType)
        if dataTypeIndex and tempArr[dataTypeIndex-1]
          mapedData[dataType].push(tempArr[dataTypeIndex-1])
        end
      end
    end


  end
end
