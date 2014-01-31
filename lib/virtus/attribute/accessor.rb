module Virtus
  class Attribute

    # Accessor extension provides methods to read and write attributes
    #
    # @example
    #
    #   attribute = Virtus::Attribute.build(String, :name => :email)
    #   model     = Class.new { attr_reader :email }
    #   object    = model.new
    #
    #   attribute.set(object, 'jane@doe.com')
    #   attribute.get(object) # => 'jane@doe.com'
    #
    module Accessor

      # Return name of this accessor attribute
      #
      # @return [Symbol]
      #
      # @api public
      attr_reader :name

      # Return instance_variable_name used by this accessor
      #
      # @api private
      attr_reader :instance_variable_name

      # @api private
      def self.extended(descendant)
        super
        name = descendant.options.fetch(:name).to_sym
        descendant.instance_variable_set('@name', name)
        descendant.instance_variable_set('@instance_variable_name', "@#{name}")
      end

      # Return if attribute value is defined
      #
      # @param [Object] instance
      #
      # @return [Boolean]
      #
      # @api public
      def defined?(instance)
        instance.instance_variable_defined?(instance_variable_name)
      end

      # Return value of the attribute
      #
      # @param [Object] instance
      #
      # @return [Object]
      #
      # @api public
      def get(instance)
        instance.instance_variable_get(instance_variable_name)
      end

      # Set value of the attribute
      #
      # @param [Object] instance
      # @param [Object] value
      #
      # @return [Object] value that was set
      #
      # @api public
      def set(instance, value)
        instance.instance_variable_set(instance_variable_name, value)
      end

      # Set default value
      #
      # @param [Object] instance
      #
      # @return [Object] value that was set
      #
      # @api public
      def set_default_value(instance)
        set(instance, default_value.call(instance, self))
      end

      # Returns a Boolean indicating whether the reader method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_reader?
        options[:reader] == :public
      end

      # Returns a Boolean indicating whether the writer method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_writer?
        options[:writer] == :public
      end

    end # Accessor

  end # Attribute
end # Virtus
