require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Set up the test database for the dummy app'
task :db do
  sh 'cd spec/dummy && bundle exec rake db:create db:migrate'
end

RSpec::Core::RakeTask.new :spec

RuboCop::RakeTask.new :lint

desc 'Run Rubocop lint checks and RSpec code examples'
task test: %w(lint spec)
