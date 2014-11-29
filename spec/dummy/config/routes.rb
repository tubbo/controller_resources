Rails.application.routes.draw do

  mount ControllerResources::Engine => "/controller_resources"
end
