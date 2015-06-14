require 'active_support/all'
require 'decent_exposure'
require 'responders'
require 'controller_resources/version'

module ControllerResources
  extend ActiveSupport::Autoload

  autoload :Engine
  autoload :Resource
  autoload :Extension
end
