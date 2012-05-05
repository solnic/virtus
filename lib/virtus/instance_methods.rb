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
      self.attributes = attributes if attributes
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
      set_attributes(attributes)
    end

    # Returns a hash of all publicly accessible attributes by
    # recursively calling #to_hash on the objects that respond to it.
    #
    # @example
    #   class Person
    #     include Virtus
    #
    #     attribute :name,    String
    #     attribute :age,     Integer
    #     attribute :email,   String, :accessor => :private
    #
    #     attribute :friend,  Person
    #   end
    #
    #   john = Person.new({ :name => 'John', :age => 28 })
    #   jack = Person.new({ :name => 'Jack', :age => 31, friend => john })
    #
    #   user.to_hash  # => { :name => 'John', :age => 28, :friend => { :name => 'Jack', :age => 31 } }
    #
    # @return [Hash]
    #
    # @api public
    def to_hash
      hash = attributes.dup
      hash.each do |key, value|
        case
        when value.is_a?(Array)
          hash[key] = value.collect do |item_within_value|
            safely_recurse_into(item_within_value) { |i| i.respond_to?(:to_hash) ? i.to_hash : i }
          end
        when value.respond_to?(:to_hash)
          hash[key] = safely_recurse_into(value) do |v| v.to_hash end
        end
      end
      hash
    end

  private

    # Get values of all attributes defined for this class, ignoring privacy
    #
    # @return [Hash]
    #
    # @api private
    def get_attributes
      self.class.attributes.each_with_object({}) do |attribute, attributes|
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
      ::Hash.try_convert(attributes).each do |name, value|
        set_attribute(name, value) if self.class.allowed_writer_methods.include?("#{name}=")
      end
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
    def set_attribute(name, value)
      __send__("#{name}=", value)
    end

    # Safely recurses into the value, avoiding StackOverflow errors.
    #
    # Accepts any value parameter, and a block, which will receive this value parameter.
    #
    # @return [Object]
    #
    # @api private
    def safely_recurse_into(value)
      Thread.current[caller.first] ||= []
      caller_stack = Thread.current[caller.first]

      return_value = nil

      if !caller_stack.include?(value.object_id)
        caller_stack.push(self.object_id)
        return_value = yield(value)
        caller_stack.pop
      end

      return_value
    end

  end # module InstanceMethods
end # module Virtus
