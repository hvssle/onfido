module Onfido
  class API
    def initialize(options = {})
      @api_key = options[:api_key]
    end

    def method_missing(method, *args)
      klass = method.to_s.split('_').collect(&:capitalize).join
      Object.const_get("Onfido::#{klass}").new(@api_key)
    rescue NameError
      super
    end

    def respond_to_missing?(method, include_private = false)
      klass = method.to_s.capitalize
      Object.const_get("Onfido::#{klass}")
      true
    rescue NameError
      super
    end
  end
end
