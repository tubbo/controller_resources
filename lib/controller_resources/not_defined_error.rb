module ControllerResources
  # Thrown when a +resource+ has not been defined, yet the controller
  # attempts to call the generated +edit_params+ method.
  class NotDefinedError < RuntimeError
    def initialize(*args)
      super
      @message = %(
        Call to #edit_params failed: Resource not defined.
      )
    end
  end
end
