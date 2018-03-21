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

    def region
      first_bit = api_key.split("_")[0]

      case first_bit
      when "live", "test" # it's an old, regionless api-token
        nil
      else # it's a new token the first bit being the region
        first_bit
      end

    rescue
      nil
    end

    def endpoint
      if region
        "https://api.#{region}.onfido.com/#{api_version}/"
      else
        "https://api.onfido.com/#{api_version}/"
      end
    end
  end
end
