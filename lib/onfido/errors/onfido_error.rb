module Onfido
  class OnfidoError < StandardError
    attr_accessor :response_code, :response_body

    def initialize(message = nil,
                   response_code: nil,
                   response_body: nil)
      @response_code = response_code
      @response_body = response_body

      super(message)
    end

    def json_body
      JSON.parse(response_body.to_s)
    rescue JSON::ParserError
      nil
    end

    def type
      json_body && json_body['error'] && json_body['error']['type']
    end

    def fields
      json_body && json_body['error'] && json_body['error']['fields']
    end
  end
end
