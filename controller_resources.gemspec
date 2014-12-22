# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'controller_resources/version'

Gem::Specification.new do |spec|
  spec.name          = "controller_resources"
  spec.version       = ControllerResources::VERSION
  spec.authors       = ["Tom Scott"]
  spec.email         = ["tubbo@psychedeli.ca"]
  spec.summary       = %q{A "glue" for decent_exposure, responders, draper and strong_params}
  spec.description   = %q{A "glue" for decent_exposure, responders, draper and strong_params}
  spec.homepage      = "https://github.com/tubbo/controller_resources"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^|spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "codeclimate-test-reporter", require: false

  spec.add_dependency "rails", ">= 4.0.0"
  spec.add_dependency "decent_exposure"
  spec.add_dependency "responders"
end
