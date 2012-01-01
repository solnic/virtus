module Virtus

  # Instance methods that are added when you include Virtus
  module InstanceMethods

    # Set attributes during initialization of an object
    #
    # @param [#to_hash] attributes
    #   the attributes hash to be set
    #
    # @return [undefined]
    #
    # @api private
    def initialize(attribute_values = {})
      self.attributes = attribute_values
    end

    # Returns a value of the attribute with the given name
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #   end
    #
    #   user = User.new(:name => 'John')
    #   user[:name]  # => "John"
    #
    # @param [Symbol] name
    #   a name of an attribute
    #
    # @return [Object]
    #   a value of an attribute
    #
    # @api public
    def [](name)
      attribute_get(name)
    end

    # Sets a value of the attribute with the given name
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #   end
    #
    #   user = User.new
    #   user[:name] = "John"  # => "John"
    #   user.name             # => "John"
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
    def []=(name, value)
      attribute_set(name, value)
    end

    # Returns a hash of all publicly accessible attributes
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #     attribute :age,  Integer
    #   end
    #
    #   user = User.new(:name => 'John', :age => 28)
    #   user.attributes  # => { :name => 'John', :age => 28 }
    #
    # @return [Hash]
    #
    # @api public
    def attributes
      attributes = {}

      self.class.attributes.each do |attribute|
        name = attribute.name
        attributes[name] = attribute_get(name) unless attribute.private_reader?
      end

      attributes
    end

    # Mass-assign of attribute values
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #     attribute :age,  Integer
    #   end
    #
    #   user = User.new
    #   user.attributes = { :name => 'John', :age => 28 }
    #
    # @param [#to_hash] attribute_values
    #   a hash of attribute values to be set on an object
    #
    # @return [Hash]
    #
    # @api public
    def attributes=(attribute_values)
      attributes = self.class.attributes
      set_attributes(attribute_values.select { |name, _value|
        attribute = attributes[name]
        attribute && !attribute.private_writer?
      })
    end

    # Returns a hash of all publicly accessible attributes
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #     attribute :age,  Integer
    #   end
    #
    #   user = User.new(:name => 'John', :age => 28)
    #   user.attributes  # => { :name => 'John', :age => 28 }
    #
    # @return [Hash]
    #
    # @api public
    def to_hash
      attributes
    end

  private

    # Mass-assign attribute values
    #
    # Only values at keys that correspond to publicly writable Attributes will
    # be set. Keys in the +attribute_values+ param can be symbols or strings.
    # Non-attribute setter methods on the receiver will not be called, and
    # privately writable attribute setter methods will not be called.
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #     attribute :age,  Integer
    #   end
    #
    #   user = User.new
    #   user.attributes = { :name => 'John', :age => 28 }
    #
    # @param [#to_hash] attribute_values
    #   a hash of attribute values to be set on an object
    #
    # @return [Hash]
    #
    # @api private
    def set_attributes(attribute_values)
      attributes = self.class.attributes
      attribute_values.each do |name, value|
        attribute = attributes[name]
        attribute_set(name, value) if attribute
      end
    end

    # Returns a value of the attribute with the given name
    #
    # @see Virtus::InstanceMethods#[]
    #
    # @return [Object]
    #
    # @api private
    def attribute_get(name)
      __send__(name)
    end

    # Sets a value of the attribute with the given name
    #
    # @see Virtus::InstanceMethods#[]=
    #
    # @return [Object]
    #
    # @api private
    def attribute_set(name, value)
      __send__("#{name}=", value)
    end

  end # module InstanceMethods
end # module Virtus
