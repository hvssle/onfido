module Onfido
  module Configuration
    attr_accessor :api_key, :open_timeout, :read_timeout, :api_version

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
      self.api_version = 'v2'
      RestClient.log = nil
    end

    def logger=(log)
      unless log.respond_to?(:<<)
        raise "#{log.class} doesn't seem to behave like a logger!"
      end

      RestClient.log = log
    end

    def logger
      RestClient.log ||= NullLogger.new
    end

    def endpoint
      "https://api.onfido.com/#{api_version}/"
    end
  end
end
