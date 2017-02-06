module ControllerResources
  class Engine < Rails::Engine
    config.controller_resources = ActiveSupport::OrderedOptions.new
  end
end
