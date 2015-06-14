module ControllerResources
  # Extensions for the including Rails app.
  class Engine < ::Rails::Engine
    isolate_namespace ControllerResources

    config.to_prepare do
      ApplicationController.class_eval do
        include ControllerResources::Extension
      end
    end
  end
end
