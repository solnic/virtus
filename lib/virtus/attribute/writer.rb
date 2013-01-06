module Virtus
  class Attribute

    class Writer

      attr_reader :name

      attr_reader :visibility

      attr_reader :default_value

      attr_reader :primitive

      # @api private
      def initialize(name, options = {})
        @name                   = "#{name}=".to_sym
        @visibility             = options.fetch(:visibility, :public)
        @instance_variable_name = "@#{name}".to_sym
        @default_value          = DefaultValue.build(options[:default])
        @primitive              = options.fetch(:primitive)
      end

      # Sets instance variable of the attribute
      #
      # @example
      #   attribute.set!(instance, value)  # => value
      #
      # @return [self]
      #
      # @api public
      def set(instance, value)
        instance.instance_variable_set(@instance_variable_name, value)
      end

      # @api public
      def public?
        @visibility == :public
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
