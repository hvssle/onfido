module Onfido
  class Resource
    VALID_HTTP_METHODS = %i(get post)

    def url_for(path)
      Onfido.endpoint + path
    end

    VALID_HTTP_METHODS.each do |method|
      define_method method do |*args|
        make_request(
          method: method.to_sym,
          url: args.first.fetch(:url),
          payload: build_query(args.first.fetch(:payload))
        )
      end
    end

    private

    def make_request(options)
      url = options.fetch(:url)
      payload = options.fetch(:payload)
      method = options.fetch(:method)

      request_options = {
        url: url,
        payload: payload,
        method: method,
        headers: headers,
        open_timeout: Onfido.open_timeout,
        timeout: Onfido.read_timeout
      }

      response = RestClient::Request.execute(request_options)

      parse(response)
    rescue RestClient::ExceptionWithResponse => e
      if e.response
        handle_api_error(e.response)
      else
        handle_restclient_error(e, url)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      handle_restclient_error(e, url)
    end

    def parse(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      general_api_error(response.code, response.body)
    end

    def headers
      {
        'Authorization' => "Token token=#{Onfido.api_key}",
        'Accept' => "application/json"
      }
    end

    # There seems to be a serialization issue with the HTTP client
    # which does not serialize the payload properly.
    # Have a look here https://gist.github.com/PericlesTheo/cb35139c57107ab3c84a

    def build_query(payload)
      if payload[:file]
        payload
      else
        Rack::Utils.build_nested_query(payload)
      end
    end

    def handle_api_error(response)
      parsed_response = parse(response)

      unless parsed_response["error"]
        general_api_error(response.code, response.body)
      end

      if Onfido.throws_exceptions
        raise RequestError.new(
          parsed_response["error"]['message'],
          type: parsed_response["error"]["type"],
          fields: parsed_response["error"]["fields"],
          response_code: response.code)
      else
        parsed_response
      end
    end

    def general_api_error(response_code, response_body)
      raise RequestError.new(
        "Invalid response object from API: #{response_body} " \
        "(HTTP response code was #{response_code})",
        response_code: response_code
      )
    end

    def handle_restclient_error(e, url)
      connection_message =
        "Please check your internet connection and try again. " \
        "If this problem persists, you should let us know at info@onfido.com."

      message =
        case e
        when RestClient::RequestTimeout
          "Could not connect to Onfido (#{url}). #{connection_message}"

        when RestClient::ServerBrokeConnection
          "The connection to the server (#{url}) broke before the " \
          "request completed. #{connection_message}"

        when RestClient::SSLCertificateNotVerified
            "Could not verify Onfido's SSL certificate. Please make sure " \
            "that your network is not intercepting certificates. " \
            "(Try going to #{Onfido.endpoint} in your browser.) " \
            "If this problem persists, let us know at info@onfido.com."

        when SocketError
            "Unexpected error when trying to connect to Onfido. " \
            "You may be seeing this message because your DNS is not working. " \
            "To check, try running 'host onfido.com' from the command line."

        else
          "Unexpected error communicating with Onfido. " \
          "If this problem persists, let us know at info@onfido.com."
        end

      full_message = message + "\n\n(Network error: #{e.message})"

      raise ConnectionError.new(full_message)
    end
  end
end
