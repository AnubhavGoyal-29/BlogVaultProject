class V2::Test
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, type: Integer
  field :number_of_websites, type: Integer
  field :started_at, type: Time
  field :number, type: Integer

  scope :running, -> { where(:status => Status::RUNNING)}
  scope :completed, -> { where(:status => Status::COMPLETED)}

  module Status
    INITIALIZED = 0
    RUNNING =1
    COMPLETED = 2
    FAILED = 3
  end

  STATUS = {}
  Status.constants.each { |type|
    STATUS[Status.class_eval(type.to_s)] = type
  }

  def history_of_tests(time1, time2)
    total_urls = {}
    wordpress_urls = {}
    ratio = {}
    V2::Test.where({:created_at.gte => time1, :created_at.lte => time2}).each do |test|
      total_urls[test.number] = test.number_of_websites
      wordpress_urls[test.number] = V2::SiteDataInfo.where(:test => test).count
      ratio[test.number] = (wordpress_urls[test.number].to_f / total_urls[test.number].to_f) * 500
    end

    data = []
    data << {:name => "Total Websites", :data => total_urls}
    data << {:name => "Wordpress Sites", :data => wordpress_urls}
    data << {:name => "Avg", :data => ratio}
    return data
  end
end
