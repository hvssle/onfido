module Onfido
  module Requestable
    def make_request(url:, payload:, method:)
      RestClient::Request.execute(url: url, payload: payload, method: method, headers: headers) do |response, *|
        ResponseHandler.new(response).parse!
      end
    end
  end
end
