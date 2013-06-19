module Virtus
  class Attribute

    # Abstract accessor method class
    #
    # @api public
    #
    # @abstract
    class AccessorMethod
      include Adamantium::Flat

      include AbstractType

      abstract_method :call

      abstract_method :define_method

      # Return name
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :name

      # Return visibility
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :visibility

      # Return instance variable name
      #
      # @return [Symbol]
      #
      # @api private
      attr_reader :instance_variable_name

      # Return options
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :options

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
        @options                = options
        @visibility             = options.fetch(:visibility, :public)
        @instance_variable_name = "@#{name}".to_sym
      end

      # Return if the accessor is public
      #
      # @return [TrueClass,FalseClass]
      #
      # @api private
      def public?
        visibility == :public
      end

    end # class AccessorMethod

  end # class Attribute
end # module Virtus
