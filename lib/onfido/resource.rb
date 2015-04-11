module Onfido
  class Resource
    VALID_HTTP_METHODS = %i(get post)

    include Requestable

    def url_for(path)
      Onfido.endpoint + path
    end

    def method_missing(method, *args)
      if VALID_HTTP_METHODS.include?(method.to_sym)
        make_request(
          url: args.first.fetch(:url),
          payload: build_query(args.first.fetch(:payload)),
          method: method.to_sym
        )
      else
        raise NoMethodError.new("undefined method '#{method}' for #{self.class}")
      end
    end

    private

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
  end
end
