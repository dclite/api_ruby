# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dcliterb/version'

Gem::Specification.new do |spec|
  spec.name          = "dcliterb"
  spec.version       = DCLiterb::VERSION
  spec.authors       = ["Alexandr Prokopenko"]
  spec.email         = ["prokopenko@igc.ru"]
  spec.summary       = "DC Lite service API"
  spec.description   = "Interface for api.dclite.app service API"
  spec.homepage      = "https://github.com/dclite/api_ruby"
  spec.licenses       = ['MIT']
  spec.metadata    = { "source_code_uri" => "https://github.com/dclite/api_ruby" }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib/dcliterb"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'faraday', "~> 0.9"
  spec.add_runtime_dependency 'faraday_middleware', "~> 0.9"
end
