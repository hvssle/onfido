module Onfido
  module Configuration
    attr_accessor :api_key, :open_timeout, :read_timeout

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def reset
      self.api_key = nil
      self.open_timeout = 30
      self.read_timeout = 80
      RestClient.log = nil
    end

    def logger=(log)
      if log.respond_to?(:<<)
        RestClient.log = log
      else
        raise "#{log.class} doesn't seem to behave like a logger!"
      end
    end

    def logger
      RestClient.log ||= NullLogger.new
    end

    def endpoint
      'https://api.onfido.com/v1/'
    end
  end
end
