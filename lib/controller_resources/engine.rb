module ControllerResources
  class Engine < Rails::Engine
    initializer 'controller_resources.configuration' do
      config.controller_resources = ActiveSupport::Configuration.new
      config.finder_method = ControllerResources::DEFAULT_FINDER_METHOD
      config.search_method = ControllerResources::DEFAULT_SEARCH_METHOD
      config.finder_param = ControllerResources::DEFAULT_FINDER_PARAM
    end
  end
end
