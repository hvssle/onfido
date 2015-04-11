module Onfido
  class ResponseHandler
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def parse!
      if Onfido.throws_exceptions && parsed_response["error"]
        raise request_error
      else
        parsed_response
      end
    end

    private

    def parsed_response
      @parsed_response ||=
        begin
          JSON.parse(response)
        rescue JSON::ParserError
          {
            'error' => {"message" => "Unparseable response: #{response}"}
          }
        end
    end

    def request_error
      RequestError.new(parsed_response['error']['message']).tap do |error|
        error.type = parsed_response['error']["type"]
        error.fields = parsed_response['error']["fields"]
        error.response_code = response.code if response.respond_to?(:code)
      end
    end
  end
end
