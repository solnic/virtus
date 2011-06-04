module Virtus
  module InstanceMethods
    # Returns a value of the attribute with the given name
    #
    # @param [Symbol] name
    #   a name of an attribute
    #
    # @return [Object]
    #   a value of an attribute
    #
    # @api public
    def attribute_get(name)
      __send__(name)
    end


    # Sets a value of the attribute with the given name
    #
    # @param [Symbol] name
    #   a name of an attribute
    #
    # @param [Object] value
    #   a value to be set
    #
    # @return [Object]
    #   the value set on an object
    #
    # @api public
    def attribute_set(name, value)
      __send__("#{name}=", value)
    end

    # Mass-assign of attribute values
    #
    # @param [Hash] attributes
    #   a hash of attribute values to be set on an object
    #
    # @return [Hash]
    #   the attributes
    #
    # @api public
    def attributes=(attributes)
      attributes.each do |name, value|
        if self.class.public_method_defined?(writer_name = "#{name}=")
          __send__(writer_name, value)
        end
      end
    end

    # Returns a hash of all publicly accessible attributes
    #
    # @return [Hash]
    #   the attributes
    #
    # @api public
    def attributes
      attributes = {}

      self.class.attributes.each do |name, attribute|
        if self.class.public_method_defined?(name)
          attributes[name] = __send__(attribute.name)
        end
      end

      attributes
    end
  end # InstanceMethods
end # Virtus
