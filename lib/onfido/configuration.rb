module Onfido
  module Configuration
    attr_accessor :api_key, :throws_exceptions

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def reset
      self.api_key = nil
      self.throws_exceptions = true
    end

    def endpoint
      'https://api.onfido.com/v1/'
    end
  end
end
