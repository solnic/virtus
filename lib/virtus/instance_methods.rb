module Virtus

  # Instance methods that are added when you include Virtus
  module InstanceMethods

    module Constructor

      # Set attributes during initialization of an object
      #
      # @param [#to_hash] attributes
      #   the attributes hash to be set
      #
      # @return [undefined]
      #
      # @api private
      def initialize(attributes = nil)
        self.class.attribute_set.set(self, attributes) if attributes
        set_default_attributes
      end

    end # Constructor

    module MassAssignment

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
        attribute_set.get(self)
      end
      alias_method :to_hash, :attributes

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
        attribute_set.set(self, attributes)
      end

    end # MassAssignment

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
      public_send(name)
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
      public_send("#{name}=", value)
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
      set_default_attributes!
      super
    end

    # Reset an attribute to its default
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
    #     attribute :age,  Integer, default: 21
    #   end
    #
    #   user = User.new(:name => 'John', :age => 28)
    #   user.age = 30
    #   user.age # => 30
    #   user.reset_attribute(:age)
    #   user.age # => 21
    #
    # @api public
    def reset_attribute(attribute_name)
      attribute = attribute_set[attribute_name]
      attribute.set_default_value(self) if attribute
      self
    end

    # Set default attributes
    #
    # @return [self]
    #
    # @api private
    def set_default_attributes
      attribute_set.set_defaults(self)
      self
    end

    # Set default attributes even lazy ones
    #
    # @return [self]
    #
    # @api public
    def set_default_attributes!
      attribute_set.set_defaults(self, proc { |object, attribute| attribute.defined?(object) })
      self
    end

    private

    # The list of allowed public methods
    #
    # @return [Array<String>]
    #
    # @api private
    def allowed_methods
      public_methods.map(&:to_s)
    end

    # @api private
    def assert_valid_name(name)
      if respond_to?(:attributes) && name.to_sym == :attributes || name.to_sym == :attribute_set
        raise ArgumentError, "#{name.inspect} is not allowed as an attribute name"
      end
    end

  end # module InstanceMethods
end # module Virtus
