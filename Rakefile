require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Set up the test database for the dummy app'
task :db do
  sh 'cd spec/dummy && bundle exec rake db:create db:migrate'
end

# Run RSpec code examples
RSpec::Core::RakeTask.new :test

# Run RuboCop lint checks
RuboCop::RakeTask.new :lint

# Clear out default Bundler release task
Rake::Task['release'].clear

desc "Release this gem to RubyGems.org via Travis-CI"
task release: %w(
  build release:guard_clean release:source_control_push
) do
  Bundler.ui.confirm 'Please wait for Travis-CI to build the gem'
  Bundler.ui.confirm 'https://travis-ci.org/tubbo/controller_resources'
end

# CI task
task default: %i(lint db test build)
