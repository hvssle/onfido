module Onfido
  class API
    def method_missing(method, *args)
      klass = method.to_s.capitalize
      Object.const_get("Onfido::#{klass}").new
    rescue
      raise NoMethodError.new("undefined method '#{method}' for #{self.class}")
    end
  end
end
