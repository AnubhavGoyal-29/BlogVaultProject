class GetSiteData
  class<<self
    def start_scraping_html(urls_data)
      data = []
      for index in 0..urls_data[1].size-1 do
        html = urls_data[1][index]
        hashedData = Hash.new{|h,k| h[k] = []}

        get_data_from_resource(html,'script','plugins',hashedData)
        get_data_from_resource(html,'script','themes',hashedData)
        get_data_from_resource(html,'script','js',hashedData)
        get_data_from_resource(html,'link','js',hashedData)

        data << [urls_data[0][index],hashedData,urls_data[2][index]]
      end
      return data
    end



    def get_data_from_resource(html,resource,dataType,hashedData)
      resource_data = html.css(resource)
      resource_data.each do |line|
        get_data_from_sub_source(line,dataType,'src',hashedData)
        get_data_from_sub_source(line,dataType,'href',hashedData)
      end
    end

    def get_data_from_sub_source(line,dataType,subResource,hashedData)
      if line[subResource] and line[subResource][dataType]
        tempArr = line[subResource].split('/')          #tempArr stores string values spllitted by '/' sign in order to obtain resource and its next value
        tempArr = tempArr.reverse
        dataTypeIndex = tempArr.index(dataType)
        if dataTypeIndex and tempArr[dataTypeIndex-1]
          hashedData[dataType].push(tempArr[dataTypeIndex-1])
        end
      end
    end


  end
end
