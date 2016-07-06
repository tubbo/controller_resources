require 'active_support/concern'
require 'controller_resources/version'
require 'controller_resources/engine'

# A mixin for +ActionController+ for easily and consistently finding
# resource objects to be used in the controller and view layer.
module ControllerResources
  extend ActiveSupport::Concern

  included do
    # @!attribute [rw]
    #   @return [String] Name of the resource we're operating on.
    class_attribute :resource_name

    # @!attribute [rw]
    #   @return [String] Name of the instance var acting as the ancestor.
    class_attribute :resource_ancestor_name

    # @!attribute [rw]
    #   @return [Array<Symbol>] Actions that need a collection resource.
    class_attribute :collection_actions do
      %w(index)
    end
  end

  class_methods do
    # Define the resource this controller will be manipulating, and call
    # the +:find_resource+ callback before most actions in order to set
    # up the resource automatically.
    #
    # @param [Symbol] name - Lowercased name of the resource.
    # @option [Symbol] :ancestor - Optional ancestor ivar name.
    def resource(name, ancestor: nil)
      self.resource_name = name.to_s
      self.resource_ancestor_name = ancestor.to_s if ancestor.present?

      before_action :find_resource, except: [:new, :create]
    end
  end

  protected

  # Pluralized name of the resource.
  #
  # @protected
  # @return [String]
  def plural_resource_name
    resource_name.pluralize
  end

  # Runs before every action to determine its resource in an instance
  # variable.
  #
  # @protected
  def find_resource
    if collection?
      instance_variable_set "@#{plural_resource_name}", collection
    else
      instance_variable_set "@#{resource_name}", model
    end
  end

  # Find the collection by its search params.
  #
  # @protected
  # @return [Object]
  def collection
    model_class.send search_method, search_params
  end

  # Find the model by its ID, or return a new model.
  #
  # @protected
  # @return [Object]
  def model
    model_class.find model_id
  end

  # Find the ancestor of this model if it's defined. Used in the
  # +model_class+ to use as the base object by which we derive models in
  # this controller.
  #
  # @protected
  # @return [Object] or +nil+ if the ancestor was not configured.
  def ancestor
    return unless resource_ancestor_name.present?
    instance_variable_get "@#{resource_ancestor_name}"
  end

  private

  # Test whether current +action_name+ is in the +collection_actions+
  # Array.
  #
  # @return [Boolean] +true+ if action needs a collection as its resource.
  def collection?
    collection_actions.include? action_name
  end

  # Override to provide your own, default is +:where+.
  #
  # @private
  # @return [Symbol] Method on the model class used to search.
  def search_method
    :where
  end

  # Override this method to provide your own search params.
  #
  # @private
  # @return [ActionController::Parameters] Params given to the search
  # method.
  def search_params
    params
  end

  # @private
  # @return [Class] Class constant for the given resource derived from
  # +resource_name+.
  def model_class
    ancestor.send(plural_resource_name) || resource_name.classify.constantize
  end

  # Override to provide your own finder param.
  #
  # @private
  # @return [String] Param used to find a model, by default +params[:id]+
  def model_id
    params[:id]
  end
end
