Rails.application.routes.draw do

  resources :posts
  resources :posts
  mount ControllerResources::Engine => "/controller_resources"
end
