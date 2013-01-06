module Virtus
  class AccessorMethod

    attr_reader :name

    attr_reader :visibility

    attr_reader :instance_variable_name

    # @api private
    def initialize(name, options = {})
      @name                   = name.to_sym
      @visibility             = options.fetch(:visibility, :public)
      @instance_variable_name = "@#{name}".to_sym
    end

    # @api public
    def public?
      visibility == :public
    end

    # @api private
    def call(*)
      raise NotImplementedError
    end

    # @api private
    def define_method
      raise NotImplementedError
    end

  end # class AccessorMethod
end # module Virtus
