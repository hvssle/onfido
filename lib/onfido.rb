require 'json'
require 'rack'
require 'rest-client'

require 'onfido/version'
require 'onfido/configuration'
require 'onfido/request_error'
require 'onfido/response_handler'
require 'onfido/null_logger'
require 'onfido/requestable'
require 'onfido/resource'
require 'onfido/address'
require 'onfido/applicant'
require 'onfido/api'


module Onfido
  extend Configuration
end
