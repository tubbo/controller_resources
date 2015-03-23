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
      # Attributes for configuring ControllerResources.
      class_attribute :_search_params
      class_attribute :_edit_params
      class_attribute :_singleton_resource
      class_attribute :_collection_resource
      class_attribute :_finder_method
      class_attribute :_protected_actions

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
      def resource(name=nil, &block)
        name = self.name.gsub(/Controller/, '').tableize if name.nil?
        self._singleton_resource = name.to_s.singularize.to_sym
        self._collection_resource = name.to_s.pluralize.to_sym
        self._protected_actions = %w(create update destroy edit new)

        class_eval <<-RUBY
          expose :#{model}, except: %w(index)
          expose :#{collection}, only: %w(index) do
            #{model_class}.where(search_params)
          end
          #{authenticate if defined? Devise}
          #{authorize if defined? Authority}
        RUBY

        yield if block_given?
      end

      protected
      # Set the search params for this controller.
      def search(*hash_of_params)
        self._search_params = hash_of_params
      end

      # Set the edit params for this controller.
      def modify(*hash_of_params)
        self._edit_params = hash_of_params
      end

      def protect(action)
        self._protected_actions << action
      end

      private
      def authenticate
        "before_action :authenticate_user!, only: %w(#{_protected_actions.join(' ')})"
      end

      def authorize
        "authorize_actions_for #{model.to_s.classify}, only: %w(#{_protected_actions.join(' ')})"
      end

      def model_class
        @model_class ||= self._singleton_resource.to_s.classify
      end

      def model
        self._singleton_resource
      end

      def collection
        @collection ||= self._collection_resource.to_s
      end
    end

    def search_params
      params.permit self.class._search_params
    end

    def edit_params
      params.require(self.class._singleton_resource).permit self._edit_params
    end
  end
end
