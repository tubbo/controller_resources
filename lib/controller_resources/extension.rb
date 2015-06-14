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
  #
  #     def show
  #       respond_with artist
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

      helper_method :current_resource
    end

    # Macros included into the controller as class methods.
    module ClassMethods
      # Initialize this controller as an authenticated resource. You can
      # optionally specify search_params and edit_params which are
      # formed into strong parameter hashes.
      #
      # Example:
      #
      #   resource :post do
      #     search :title
      #     modify :title, :body
      #   end
      #
      # @param [String] name - The parameterized name of the model
      #                        backing this controller.
      def resource(name = self.name.gsub(/Controller/, '').tableize, &block)
        self._resource = Resource.new(name, &block)

        expose(
          _resource.model_name,
          except: %i(index)
        )
        expose(
          _resource.collection_name,
          only: %i(index),
          attributes: :search_params
        )
      end
    end

    # Omit any unpermitted parameters when searching in collections.
    # Permits all parameters when none are given in the resource block.
    #
    # @returns [StrongParameters::Hash]
    def search_params
      if resource.search_params.any?
        params.permit resource.search_params
      else
        params.permit!
      end
    end

    # Omit any unpermitted parameters when editing or creating content.
    # Permits all parameters when none are given in the resource block.
    #
    # @returns [StrongParameters::Hash]
    def edit_params
      if resource.edit_params.any?
        params.require(resource.model_name).permit resource.edit_params
      else
        params.require(resource.model_name).permit!
      end
    end

    # The resource object as made available to the controller
    #
    # @returns [Resource]
    def resource
      fail Resource::NotConfiguredError unless self.class._resource.present?
      self.class._resource
    end

    # A helper for engines like Pundit to configure the current
    # authorizer policy for this controller.
    #
    # @returns [Object] the class name of the configured model resource.
    def current_resource
      resource.model_class
    end
  end
end
