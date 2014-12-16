module ControllerResources
  class Engine < ::Rails::Engine
    isolate_namespace ControllerResources

    config.to_prepare do
      ApplicationController.class_eval do
        include ControllerResources::Extension
      end
    end
  end
end
