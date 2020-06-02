require 'httparty'


# response = HTTParty.get('https://api.adapools.org/v0/pools?api_key=4cf2ba49ee3b4ce9dc74073d5')

# puts response.body, response.code, response.message, response.headers.inspect


class AdaPool
  include HTTParty
  base_uri 'api.adapools.org'

  def request
    api_key = '4cf2ba49ee3b4ce9dc74073d5'
    options = { :basic_auth => { :username => api_key } }
    self.class.post("/v0/pools", options)
  end
end

