module Onfido
  module Requestable
    def make_request(options)
      url = options.fetch(:url)
      payload = options.fetch(:payload)
      method = options.fetch(:method)
      RestClient::Request.execute(url: url, payload: payload, method: method, headers: headers) do |response, *|
        ResponseHandler.new(response).parse!
      end
    end
  end
end
