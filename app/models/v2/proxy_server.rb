class V2::ProxyServer 
  include Mongoid::Document
  include Mongoid::Timestamps

  field :host, type: String
  field :port, type: String
  field :username, type: String
  field :password, type: String
end
