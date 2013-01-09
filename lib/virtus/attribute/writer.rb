module Virtus
  class Attribute

    # Writer method object
    #
    # @api public
    class Writer < AccessorMethod

      attr_reader :primitive

      # Return default value instance
      #
      # @return [DefaultValue]
      #
      # @api private
      attr_reader :default_value

      # Initialize a writer instance
      #
      # @param [#to_sym] name
      #
      # @param [Hash] options
      #
      # @return [undefined]
      #
      # @api private
      def initialize(name, options = {})
        super
        @name          = "#{name}=".to_sym
        @primitive     = options.fetch(:primitive, ::Object)
        @default_value = DefaultValue.build(options[:default])
      end

      # Sets instance variable of the attribute
      #
      # @example
      #   attribute.set!(instance, value)  # => value
      #
      # @return [self]
      #
      # @api public
      def call(instance, value)
        instance.instance_variable_set(instance_variable_name, value)
      end

      # Creates an attribute writer method
      #
      # @param [Module] mod
      #
      # @return [self]
      #
      # @api private
      def define_method(accessor, mod)
        mod.define_writer_method(accessor, name, visibility)
        self
      end

    end # class Writer

  end # class Attribute
end # module Virtus
