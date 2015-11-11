module Onfido
  class OnfidoError < StandardError
    attr_accessor :type, :response_code, :response_body

    def initialize(message = nil,
                   type: nil,
                   response_code: nil,
                   response_body: nil)
      @type = type
      @response_code = response_code
      @response_body = response_body

      super(message)
    end
  end
end
