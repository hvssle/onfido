require 'json'
require 'rack'
require 'rest-client'
require 'open-uri'

require 'onfido/version'
require 'onfido/configuration'
require 'onfido/request_error'
require 'onfido/response_handler'
require 'onfido/null_logger'
require 'onfido/requestable'
require 'onfido/resource'
require 'onfido/address'
require 'onfido/applicant'
require 'onfido/document'
require 'onfido/check'
require 'onfido/report'
require 'onfido/api'
require 'onfido/dinosaur'


module Onfido
  extend Configuration
end
