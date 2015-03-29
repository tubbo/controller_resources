require 'decent_exposure'
require 'responders'

module ControllerResources
  # A single macro that combines all controller-level macros we use for
  # the front-end of this application. Simply use the
  # `resource :resource_name` macro in your controller class
  # to make it work.
  #
  # Example:
  #
  #   class ArtistsController < ApplicationController
  #     resource :artist
  #
  #     def index
  #       respond_with artists
  #     end
  #   end
  #
  module Extension
    extend ActiveSupport::Concern

    included do
      class_attribute :_resource

      # Use the StrongParameters strategy in DecentExposure
      decent_configuration do
        strategy DecentExposure::StrongParametersStrategy
        attributes :edit_params
        except %w(index)
      end

      # Use the FlashResponder and HttpCacheResponder to respond to
      # various requests.
      responders :flash, :http_cache
    end

    module ClassMethods
      # Initialize this controller as an authenticated resource.
      def resource(name = self.name.gsub(/Controller/, '').tableize, &block)
        self._resource = Resource.extend! controller, name do
          yield
        end
      end
    end

    def search_params
      params.permit resource.search_params
    end

    def edit_params
      params.require(resource.model_name).permit resource.edit_params
    end

    def resource
      self.class._resource
    end
  end
end
