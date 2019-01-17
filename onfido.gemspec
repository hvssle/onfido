# coding: utf-8

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onfido/version'

Gem::Specification.new do |spec|
  spec.name          = 'onfido'
  spec.version       = Onfido::VERSION
  spec.authors       = ['Pericles Theodorou', 'Grey Baker']
  spec.email         = ['periclestheo@gmail.com', 'grey@gocardless.com']
  spec.summary       = 'A wrapper for Onfido API'
  spec.description   = "A thin wrapper for Onfido's API. This gem supports "\
                       "both v1 and v2 of the Onfido API. Refer to Onfido's "\
                       "API documentation for details of the expected "\
                       "requests and responses for both."
  spec.homepage      = 'http://github.com/hvssle/onfido'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = ">= 2.2.0"

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
  spec.add_development_dependency 'rubocop', '~> 0.63.0'
  spec.add_development_dependency 'sinatra', '~> 1.4'
  spec.add_development_dependency 'webmock', '~> 3.0'

  spec.add_dependency 'rack', '>= 1.6.0'
  spec.add_dependency 'rest-client', '~> 2.0'
end
