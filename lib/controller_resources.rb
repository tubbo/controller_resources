require 'active_support/all'
require 'decent_exposure'
require 'controller_resources/version'
require 'controller_resources/not_defined_error'

# A DSL for ActionController that allows you to easily and quickly define
# both singular and collection model resources that can be operated on
# within the controller. Attempts to DRY up most of the boilerplate code
# at the top of each controller used to set up its state.
#
# @example
#
#   class PostsController < ApplicationController
#     include ControllerResources
#
#     resource :post do
#       permit :title, :body, :author_id
#     end
#
#     def index
#       respond_with posts
#     end
#
#     def show
#       respond_with post
#     end
#
#     def create
#       post.save
#       respond_with post
#     end
#
module ControllerResources
  extend ActiveSupport::Concern

  included do
    # Given name of the model as supplied to the +resource+ directive.
    #
    # @attr_accessor [Symbol]
    cattr_accessor :model_name

    # Collection name computed by pluralizing the given model name.
    #
    # @attr_accessor [Symbol]
    cattr_accessor :collection_name

    # A collection of arguments supplied to +StrongParameters#permit+
    # that is used in the +edit_params+ method to easily define
    # attributes which need to be whitelisted for mass assignment.
    #
    # @attr_accessor [Array]
    cattr_accessor :params_to_permit

    # Configures +DecentExposure+ to use the +edit_params+ method
    # defined by this module as the default attributes for mass
    # assignment.
    decent_configuration do
      attributes :edit_params
    end

    helper_method :model, :collection
  end

  class_methods do
    # Define resources based on the given name and decent exposure
    # options. Uses +DecentExposure+ to define said resources and
    # stores the generated names in the controller's configuration.
    #
    # If a block is given, one can also call additional DSL methods
    # like +permit+.
    #
    # @param [Symbol] name
    # @param [Hash] options
    # @param &block
    # @example
    #
    #   expose :author
    #   resource :post, ancestor: :author
    #
    def resource(name, options = {})
      self.model_name = name
      self.collection_name = "#{name}".pluralize.to_sym

      expose model_name, options
      expose collection_name, options

      yield if block_given?
    end

    private

    # Permit the given attributes in +StrongParameters+.
    #
    # @example
    #
    #   expose :author
    #   resource :post, ancestor: :author do
    #     permit :title, :body
    #   end
    #
    def permit(*permittable_params)
      self.params_to_permit = permittable_params
    end
  end

  # Reader method for the defined singular resource.
  #
  # @return [Object] or +nil+ if no resource has been defined.
  def model
    return unless resource?
    public_send model_name
  end

  # Reader method for the defined collection resource.
  #
  # @return [Object] or +nil+ if no resource has been defined.
  def collection
    return unless resource?
    public_send collection_name
  end

  # White-listed parameters for mass assignment as defined by
  # +StrongParameters+. Throws a +ControllerResources::NotDefinedError+
  # if no +resource+ block has been defined on this controller.
  #
  # @return [StrongParameters::Parameters]
  def edit_params
    fail NotDefinedError unless resource?
    params.require(model_name).permit(*params_to_permit)
  end

  private

  # Whether a +resource+ directive has been invoked on this controller.
  #
  # @private
  # @return [Boolean]
  def resource?
    model_name.present?
  end
end
