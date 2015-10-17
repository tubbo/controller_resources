module ControllerResources
  # Extends +ActionController::Base+ in the host app to include the
  # +ControllerResources+ mixin by default.
  class Engine < ::Rails::Engine
    isolate_namespace ControllerResources

    ActiveSupport.on_load :action_controller do
      ActionController::Base.class_eval do
        include ControllerResources
      end
    end
  end
end
