=begin
The class will handle response failures coming from Onfido
It's main purpose is to produce meaningful error messages to the user e.g.

  RequestError: Authorization error: please re-check your credentials

Users can also rescue the error and insect its type and affected fields as
specified in the Onfido documentation e.g.

  begin
    # error being raised
  rescue Onfido::RequestError => e
    e.type
    e.fields
  end

=end

module Onfido
  class RequestError < StandardError
    attr_accessor :type, :fields
  end
end
