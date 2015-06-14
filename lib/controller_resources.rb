require 'active_support/all'
require 'decent_exposure'
require 'responders'
require 'controller_resources/version'

# A controller DSL for Rails that allows you to easily and quickly define
# both singular and collection model resources that can be operated on
# within the controller. Attempts to DRY up most of the boilerplate code
# at the top of each controller used to set up its state.
module ControllerResources
  extend ActiveSupport::Autoload

  autoload :Engine
  autoload :Resource
  autoload :Extension
end
