require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'controller_resources/version'
require 'yard'
require 'travis/release/task'

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

# Run RSpec code examples
RSpec::Core::RakeTask.new :test

# Run RuboCop lint checks
RuboCop::RakeTask.new :lint

# Clear out default Bundler release task
Rake::Task['release'].clear

# Rake tasks for building YARD documentation
YARD::Rake::YardocTask.new :doc

# Release version to RubyGems via Travis-CI
Travis::Release::Task.new

# CI task
task default: %i(app:db:setup test build)

namespace :ci do
  desc "Rename gem package so it can be released with GitHub."
  task :package do
    version = ControllerResources::VERSION
    sh "cp pkg/controller_resources-#{version}.gem pkg/controller_resources.gem"
  end
end
