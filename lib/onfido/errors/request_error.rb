module Onfido
  class RequestError < OnfidoError
    attr_accessor :fields

    def initialize(message = nil,
                   type: nil,
                   response_code: nil,
                   response_body: nil,
                   fields: nil)
      @fields = fields

      super(message,
            type: type,
            response_code: response_code,
            response_body: response_body)
    end
  end
end
