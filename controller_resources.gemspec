# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'controller_resources/version'

Gem::Specification.new do |spec|
  spec.name = 'controller_resources'
  spec.version = ControllerResources::VERSION
  spec.authors = ['Tom Scott']
  spec.email = ['tubbo@psychedeli.ca']
  spec.summary = '
    A controller DSL for Rails that allows you to easily and quickly
    define both singular and collection model resources that can be
    operated on within the controller.
  '.strip
  spec.description = spec.summary + '
    Attempts to DRY up most of the boilerplate code at the top of
    each controller used to set up its state.
  '.strip
  spec.homepage = 'https://github.com/tubbo/controller_resources'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  # spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^|spec/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rspec-rails', '~> 3'
  spec.add_development_dependency 'pg', '~> 0'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'capybara', '~> 2'
  # spec.add_development_dependency 'poltergeist', '~> 1.7'
  spec.add_development_dependency 'database_cleaner', '~> 1'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'yard', '~> 0'
  spec.add_development_dependency 'travis-release', '~> 0'

  spec.add_dependency 'rails'
  spec.add_dependency 'decent_exposure', '~> 2'
end
