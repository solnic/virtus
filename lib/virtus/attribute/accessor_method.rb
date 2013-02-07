module Virtus
  class Attribute

    # Abstract accessor method class
    #
    # @api public
    #
    # @abstract
    class AccessorMethod
      include Adamantium::Flat

      # Return name
      #
      # @return [Symbol]
      #
      # @api public
      attr_reader :name

      # Return visibility
      #
      # @return [Symbol]
      #
      # @api public
      attr_reader :visibility

      # Return instance variable name
      #
      # @return [Symbol]
      #
      # @api public
      attr_reader :instance_variable_name

      # Initialize accessor method instance
      #
      # @param [#to_sym] name
      #
      # @param [Hash] options
      #
      # @return [undefined]
      #
      # @api private
      def initialize(name, options = {})
        @name                   = name.to_sym
        @visibility             = options.fetch(:visibility, :public)
        @instance_variable_name = "@#{name}".to_sym
      end

      # Return if the accessor is public
      #
      # @return [TrueClass,FalseClass]
      #
      # @api public
      def public?
        visibility == :public
      end

      # Call this method
      #
      # @abstract
      #
      # @api public
      def call(*)
        raise NotImplementedError
      end

      # Define method via provided module
      #
      # @param [Accessor] accessor
      #
      # @param [AttributeSet] mod
      #
      # @api private
      def define_method(accessor, mod)
        raise NotImplementedError
      end

    end # class AccessorMethod

  end # class Attribute
end # module Virtus
