require 'json'
require 'rest-client'

require 'onfido/version'
require 'onfido/configuration'
require 'onfido/request_error'
require 'onfido/response_handler'
require 'onfido/null_logger'
require 'onfido/requestable'
require 'onfido/resource'
require 'onfido/address'
require 'onfido/api'

module Onfido
  extend Configuration
end
