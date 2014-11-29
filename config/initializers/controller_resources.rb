require 'controller_resources'

class ApplicationController < ActionController::Base
  include ControllerResources::Extension
end
