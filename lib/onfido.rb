require 'json'
require 'rack'
require 'rest-client'
require 'open-uri'

require 'onfido/version'
require 'onfido/configuration'
require 'onfido/errors/onfido_error'
require 'onfido/errors/request_error'
require 'onfido/errors/server_error'
require 'onfido/errors/connection_error'
require 'onfido/null_logger'
require 'onfido/api'
require 'onfido/resource'
require 'onfido/resources/address'
require 'onfido/resources/applicant'
require 'onfido/resources/document'
require 'onfido/resources/check'
require 'onfido/resources/report'
require 'onfido/resources/webhook'

module Onfido
  extend Configuration
end
