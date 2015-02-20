# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'net/http'
require 'uri'
require "ostruct"
require "json"

class Connection

  ENDPOINT = "https://query.yahooapis.com/v1/public"
  
  def initialize(endpoint = ENDPOINT)
    uri = URI.parse(endpoint)
    @http = Net::HTTP.new(uri.host, uri.port)
  end

  def get(path, params)
	full_path = encode_path_params(path, params)
	request = Net::HTTP::Get.new(full_path)
	@http.request(request)
  end

  def post(path, params)
    request = Net::HTTP::Post.new(path)
    request.set_form_data(params)
    @http.request(request)
  end

  private

  def encode_path_params(path, params)
	encoded = URI.encode_www_form(params)
	[path, encoded].join("?")
  end

  def request_json(method, path, params)
    response = request(method, path, params)
    body = JSON.parse(response.body)

    OpenStruct.new(:code => response.code, :body => body)
  rescue JSON::ParserError
    response
  end

end

test = Connection.new	
test.get("/yql?q=select%20*%20from%20yahoo.finance.quoteslist%20where%20symbol%3D'%5Egspc'&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=", 0)

SCHEDULER.every '1m', :first_in => 0 do |job|
  send_event('yahoofinance', { })
end