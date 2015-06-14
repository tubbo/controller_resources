# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'bundler/setup'
Bundler.require :default, :development

require 'controller_resources'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rails/test_help'

CodeClimate::TestReporter.start

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end


# Configure RSpec
RSpec.configure do |config|
end
