module ControllerResources
  # Configures the +ControllerResources+ to be isolated and
  # eager-loaded.
  class Engine < ::Rails::Engine
    isolate_namespace ControllerResources

    config.eager_load_namespaces << ControllerResources
  end
end
