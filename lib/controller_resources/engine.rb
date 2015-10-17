module ControllerResources
  # Extensions for the including Rails app.
  class Engine < ::Rails::Engine
    isolate_namespace ControllerResources

    ActiveSupport.on_load :action_controller do
      ActionController::Base.class_eval do
        include ControllerResources
      end
    end
  end
end
