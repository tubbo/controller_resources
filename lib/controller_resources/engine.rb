module ControllerResources
  class Engine < ::Rails::Engine
    isolate_namespace ControllerResources
    config.to_prepare do
      require 'controller_resources'

      class ApplicationController < ActionController::Base
        include ControllerResources::Extension
      end
    end
  end
end
