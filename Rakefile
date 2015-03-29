require "bundler/gem_tasks"

desc 'Set up the test database for the dummy app'
task :db do
  sh 'cd spec/dummy && bundle exec rake db:setup'
end
