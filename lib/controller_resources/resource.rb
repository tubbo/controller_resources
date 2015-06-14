module ControllerResources
  # Data model for the controlled resource.
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

    # Thrown when a Resource object has not been configured, but we are
    # attempting to use methods defined by ControllerResources.
    class NotConfiguredError < StandardError; end

    # Instantiate a new Resource with the given name and a block to
    # define permitted parameters. The code given in the +resource+
    # block is passed directly here so that the Resource class can be
    # set up with its proper state.
    #
    # @param [Symbol] name - The name of this resource, typically given
    #                        as a singular symbol.
    #
    # @param [Block] &block - A block of code used to set up this
    #                         object.
    def initialize(name, &block)
      @name = name.to_s
      @search_params = []
      @edit_params = []
      yield if block_given?
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
      @model_class ||= model_name.classify
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
  end
end
