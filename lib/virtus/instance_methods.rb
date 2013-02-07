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
    def initialize(attributes = nil)
      hash = set_defaults(attributes || {})
      set_attributes(hash) if attributes
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
      get_attribute(name)
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
      set_attribute(name, value)
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
      get_attributes(&:public_reader?)
    end

    # Mass-assign attribute values
    #
    # Keys in the +attributes+ param can be symbols or strings.
    # All referenced Attribute writer methods *will* be called.
    # Non-attribute setter methods on the receiver *will* be called.
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
    #   user.attributes = { :name => 'John', 'age' => 28 }
    #
    # @param [#to_hash] attributes
    #   a hash of attribute names and values to set on the receiver
    #
    # @return [Hash]
    #
    # @api public
    def attributes=(attributes)
      set_attributes(coerce_input_attributes(attributes))
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

    # Freeze object
    #
    # @return [self]
    #
    # @api public
    #
    # @example
    #
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #     attribute :age,  Integer
    #   end
    #
    #   user = User.new(:name => 'John', :age => 28)
    #   user.frozen? # => false
    #   user.freeze
    #   user.frozen? # => true
    #
    # @api public
    def freeze
      set_defaults
      super
    end

  private

    # Get values of all attributes defined for this class, ignoring privacy
    #
    # @return [Hash]
    #
    # @api private
    def get_attributes
      attribute_set.each_with_object({}) do |attribute, attributes|
        name = attribute.name
        attributes[name] = get_attribute(name) if yield(attribute)
      end
    end

    # Mass-assign attribute values
    #
    # @see Virtus::InstanceMethods#attributes=
    #
    # @return [Hash]
    #
    # @api private
    def set_attributes(attributes)
      attributes.each do |name, value|
        set_attribute(name, value) if allowed_writer_methods.include?("#{name}=")
      end
    end

    # Set default attributes
    #
    # @return [hash]
    #
    # @api private
    def set_defaults(attributes = {})
      hash = coerce_input_attributes(attributes)

      (attribute_set.map(&:name) - hash.keys.map(&:to_sym)).each do |name|
        attribute = attribute_set[name]
        next if attribute.accessor.lazy? || instance_variable_defined?(attribute.reader.instance_variable_name)
        attribute.writer.set_default_value(self, attribute)
      end

      hash
    end

    # @api private
    def coerce_input_attributes(attributes)
      ::Hash.try_convert(attributes) or raise(
        NoMethodError, "Expected #{attributes.inspect} to respond to #to_hash"
      )
    end

    # Returns a value of the attribute with the given name
    #
    # @see Virtus::InstanceMethods#[]
    #
    # @return [Object]
    #
    # @api private
    def get_attribute(name)
      __send__(name)
    end

    # Sets a value of the attribute with the given name
    #
    # @see Virtus::InstanceMethods#[]=
    #
    # @return [Object]
    #
    # @api private
    def set_attribute(name, value = nil)
      __send__("#{name}=", value)
    end

    # The list of allowed public methods
    #
    # @return [Array<String>]
    #
    # @api private
    def allowed_methods
      public_methods.map(&:to_s)
    end

  end # module InstanceMethods
end # module Virtus
