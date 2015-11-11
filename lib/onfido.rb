require 'json'
require 'rack'
require 'rest-client'
require 'open-uri'

require 'onfido/version'
require 'onfido/configuration'
require 'onfido/errors/onfido_error'
require 'onfido/errors/request_error'
require 'onfido/errors/connection_error'
require 'onfido/null_logger'
require 'onfido/resource'
require 'onfido/address'
require 'onfido/applicant'
require 'onfido/document'
require 'onfido/check'
require 'onfido/report'
require 'onfido/api'

module Onfido
  extend Configuration
end
