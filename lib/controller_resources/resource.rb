module ControllerResources
  # The "data model" for the controlled resource. In the controller,
  # defining the +resource+ block instantiates this class, which is used
  # to hold all of the data the developer provides inside the block and
  # used in the +Extension+ to actually do the "heavy lifting" in the
  # controller. This class is just a way of storing all of the
  # configured state for a given controller's resource.
  class Resource
    # The name of this resource, used to look up the collection and
    # model names.
    #
    # @type [String]
    attr_reader :name

    # Permitted parameters for searching collections.
    #
    # @type [Array]
    attr_reader :search_params

    # Permitted parameters for editing members.
    #
    # @type [Array]
    attr_reader :edit_params

    # Override options for decent_exposure that apply to all exposed
    # resources.
    #
    # @type [Hash]
    attr_reader :overrides

    # Thrown when a Resource object has not been configured, but we are
    # attempting to use methods defined by ControllerResources.
    class NotConfiguredError < StandardError; end

    # Instantiate a new Resource with the given name and a block to
    # define permitted parameters. The code given in the +resource+
    # block is passed directly here so that the Resource class can be
    # set up with its proper state.
    #
    # By default, resources are not given any search or edit params. If
    # none are provided (via the +search+ and +modify+ configuration
    # methods), all parameters will be permitted on collection and
    # member resources respectively.
    #
    # @param [Symbol] name - The name of this resource, typically given
    #                        as a singular symbol.
    #
    # @param [Block] &block - A block of code used to set up this
    #                         object.
    def initialize(name, overrides={}, &block)
      @name = name.to_s
      @search_params = []
      @edit_params = []
      @block = block
      @overrides = overrides
      @model_options = { except: %i(index) }
      @collection_options = {
        only: %i(index),
        attributes: :search_params
      }
      yield self if block_given?
    end

    # Singular version of the given resource name.
    #
    # @returns [Symbol]
    def model_name
      name.singularize.to_sym
    end

    # Pluralized version of the given resource name.
    #
    # @returns [Symbol]
    def collection_name
      name.pluralize.to_sym
    end

    # The model name as a class constant.
    #
    # @returns [Object]
    def model_class
      @model_class ||= model_name.to_s.classify.constantize
    end

    # Set the search params for this controller.
    #
    # Example:
    #
    #   resource :post do
    #     search :title, :category, :tag
    #   end
    #
    # @param [Array] A collection of params to whitelist.
    def search(*params)
      @search_params = params
    end

    # Set the edit params for this controller.
    #
    # Example:
    #
    #   resource :post do
    #     modify :title, :category, :tag, :body, :is_published
    #   end
    #
    # @param [Array] A collection of params to whitelist.
    def modify(*params)
      @edit_params = params
    end

    def model(options={})
      @model_options.merge!(options)
    end

    def collection(options={})
      @collection_options.merge!(options)
    end

    def model_options
      @model_options.merge(overrides)
    end

    def collection_options
      @collection_options.merge(overrides)
    end
  end
end
