module Virtus
  module InstanceMethods
    # Chains Class.new to be able to set attributes during initialization of
    # an object.
    #
    # @param [Hash] attributes
    #   the attributes hash to be set
    #
    # @return [Object]
    #
    # @api private
    def initialize(attributes = {})
      self.attributes = attributes
    end

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
        writer_name = "#{name}="
        __send__(writer_name, value) if respond_to?(writer_name)
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
        attributes[name] = __send__(attribute.name) if respond_to?(name)
      end

      attributes
    end
  end # InstanceMethods
end # Virtus
