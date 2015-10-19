require 'active_support/all'
require 'decent_exposure'
require 'controller_resources/version'

# A mixin for ActionController that helps define singular and collection
# model resources with permitted attributes all in one big macro.
module ControllerResources
  extend ActiveSupport::Autoload

  autoload :NotDefinedError
  autoload :Extension
  autoload :Engine
end

ActiveSupport.on_load :action_controller do
  include ControllerResources::Extension
end
