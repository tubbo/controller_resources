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
      class_attribute :_search_params
      class_attribute :_edit_params
      class_attribute :_singleton_resource
      class_attribute :_collection_resource

      # Use the StrongParameters strategy
      decent_configuration do
        strategy DecentExposure::StrongParametersStrategy
        attributes :edit_params
        except %w(index)
      end

      # Use the FlashResponder and HttpCacheResponder
      responders :flash, :http_cache
    end

    module ClassMethods
      # Initialize this controller as an authenticated resource.
      def resource(name=nil, &block)
        name = self.name.gsub(/Controller/, '').tableize if name.nil?
        self._singleton_resource = name.to_s.singularize.to_sym
        self._collection_resource = name.to_s.pluralize.to_sym

        class_eval <<-RUBY
          respond_to :html
          expose :#{self._singleton_resource}, except: %w(index)
          expose :#{self._collection_resource}, only: %w(index) do
            #{self._singleton_resource.to_s.classify}.where(search_params)
          end
          #{authenticate if defined? Devise}
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

      private
      def authenticate
        "before_action :authenticate_user!, except: %w(index show)"
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
