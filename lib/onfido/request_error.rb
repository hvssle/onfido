module Onfido
  class RequestError < StandardError
    attr_accessor :type, :fields
  end
end
