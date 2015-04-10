require 'onfido/address_picker'

module Onfido
  class API
    include Requestable
    include AddressPicker

    def url_for(path)
      Onfido.endpoint + path
    end

    def method_missing(method, *args)
      if [:get, :post].include?(method.to_sym)
        make_request(url: args.first.fetch(:url), payload: args.first.fetch(:payload), method: method.to_sym)
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
  end
end
