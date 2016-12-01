module Onfido
  class Resource
    VALID_HTTP_METHODS = %i(get post put delete).freeze
    REQUEST_TIMEOUT_HTTP_CODE = 408

    def initialize(api_key = nil)
      @api_key = api_key || Onfido.api_key
    end

    def url_for(path)
      Onfido.endpoint + path
    end

    VALID_HTTP_METHODS.each do |method|
      define_method method do |*args|
        make_request(
          method: method.to_sym,
          url: args.first.fetch(:url),
          payload: build_query(args.first.fetch(:payload, {}))
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

      #response should be parsed only when there is a response expected
      parse(response) unless response.code == 204 #no_content
    rescue RestClient::ExceptionWithResponse => error
      if error.response && !timeout_response?(error.response)
        handle_api_error(error.response)
      else
        handle_restclient_error(error, url)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => error
      handle_restclient_error(error, url)
    end

    def parse(response)
      content_type = response.headers[:content_type]
      if content_type && content_type.include?("application/json")
        JSON.parse(response.body.to_s)
      else
        response.body
      end
    rescue JSON::ParserError
      general_api_error(response.code, response.body)
    end

    def timeout_response?(response)
      response.code.to_i == REQUEST_TIMEOUT_HTTP_CODE
    end

    def headers
      {
        'Authorization' => "Token token=#{@api_key}",
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

      error_class = response.code.to_i >= 500 ? ServerError : RequestError

      raise error_class.new(
        parsed_response["error"]['message'],
        response_code: response.code,
        response_body: response.body
      )
    end

    def general_api_error(response_code, response_body)
      error_class = response_code.to_i >= 500 ? ServerError : RequestError

      raise error_class.new(
        "Invalid response object from API: #{response_body} " \
        "(HTTP response code was #{response_code})",
        response_code: response_code,
        response_body: response_body
      )
    end

    def handle_restclient_error(error, url)
      connection_message =
        "Please check your internet connection and try again. " \
        "If this problem persists, you should let us know at info@onfido.com."

      message =
        case error
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

      full_message = message + "\n\n(Network error: #{error.message})"

      raise ConnectionError.new(full_message)
    end
  end
end
