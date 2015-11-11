# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onfido/version'

Gem::Specification.new do |spec|
  spec.name          = 'onfido'
  spec.version       = Onfido::VERSION
  spec.authors       = ['Pericles Theodorou']
  spec.email         = ['periclestheo@gmail.com']
  spec.summary       = %q{A wrapper for Onfido API 1.0}
  spec.description   = %q{A wrapper for Onfido API 1.0}
  spec.homepage      = 'http://github.com/hvssle/onfido'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'webmock', '~> 1.22'
  spec.add_development_dependency 'rubocop', '~> 0.35.0'

  spec.add_dependency 'rest-client', '~> 1.8.0'
end
