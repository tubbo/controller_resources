require 'bundler/gem_tasks'

desc 'Set up the test database for the dummy app'
task :db do
  sh 'cd spec/dummy && bundle exec rake db:create db:migrate'
end

begin
  require 'bundler/setup'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new :test
rescue LoadError; end
