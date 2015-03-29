module ControllerResources
  # Data model for the controlled resource.
  class Resource
    attr_reader :name, :search_params, :edit_params

    def initialize(name, &block)
      @name = name.to_s
      @actions = %w(create update destroy edit new)
      @search_params = []
      @edit_params = []
      yield if block_given?
    end

    # Public: Extends the controller with this resource's extensions.
    def self.extend!(controller, name, &block)
      resource = new(name) { yield }
      controller.class_eval resource.controller_extensions
      resource
    end

    # Internal: DecentExposure, Devise and Authority macros for the
    # controller. This is included into the controller when you call
    # `resource` on the class.
    def controller_extensions
      %<
        expose :#{model_name}, except: %w(index)
        expose :#{collection_name}, only: %w(index) do
          #{model_class}.where(search_params)
        end
        #{authenticate if devise?}
        #{authorize if authority?}
      >
    end

    def model_name
      name.singularize
    end

    def collection_name
      name.pluralize
    end

    def actions(*new_actions)
      @actions = new_actions
    end

    # Set the search params for this controller.
    def search(*params)
      @search_params = params
    end

    # Set the edit params for this controller.
    def modify(*params)
      @edit_params = params
    end

    # Add an action to the list of protected actions.
    def protect(action)
      @actions << action
    end

    # Remove an action from the list of protected actions.
    def unprotect(action)
      @actions = @actions.reject { |existing| existing == action.to_s }
    end

    private
    def protected_actions
      @actions.join(' ')
    end

    def authenticate
      "before_action :authenticate_user!, only: %w(#{protected_actions})"
    end

    def authorize
      "authorize_actions_for #{model.to_s.classify}, only: %w(#{protected_actions})"
    end

    def model_class
      @model_class ||= model_name.classify
    end

    def devise?
      defined? Devise
    end

    def authority?
      defined? Authority
    end
  end
end
