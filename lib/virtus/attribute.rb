module Virtus
  # Abstract class implementing base API for attribute types
  #
  # @abstract
  class Attribute
    # Returns default options hash for a given attribute class
    #
    # @example
    #   Virtus::Attribute::String.options
    #   # => {:primitive => String, :complex => false}
    #
    # @return [Hash]
    #   a hash of default option values
    #
    # @api public
    def self.options
      options = {}
      accepted_options.each do |method|
        value = send(method)
        options[method] = value unless value.nil?
      end
      options
    end

    # Returns an array of valid options
    #
    # @example
    #   Virtus::Attribute::String.accepted_options
    #   # => [:primitive, :complex, :accessor, :reader, :writer]
    #
    # @return [Array]
    #   the array of valid option names
    #
    # @api public
    def self.accepted_options
      @accepted_options ||= []
    end

    # Defines which options are valid for a given attribute class
    #
    # @example
    #   class MyAttribute < Virtus::Attribute::Object
    #     accept_options :foo, :bar
    #   end
    #
    # @return [Array]
    #   All accepted options
    #
    # @api public
    def self.accept_options(*args)
      accepted_options.concat(args)

      # create methods for each new option
      args.each { |option| add_option_method(option) }

      # add new options to all descendants
      descendants.each { |descendant| descendant.accepted_options.concat(args) }

      accepted_options
    end

    # Adds a reader/writer method for the give option name
    #
    # @return [NilClass]
    #
    # @api private
    def self.add_option_method(option)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{option}(value = Undefined)          # def self.unique(value = Undefined)
          return @#{option} if value.equal?(Undefined) #   return @unique if value.equal?(Undefined)
          @#{option} = value                           #   @unique = value
        end                                            # end
      RUBY
    end
    private_class_method :add_option_method

    # Returns all the descendant classes
    #
    # @example
    #   Virtus::Attribute::Numeric.descendants
    #   # => [Virtus::Attribute::Decimal, Virtus::Attribute::Float, Virtus::Attribute::Integer]
    #
    # @return [Array]
    #   the array of descendants
    #
    # @api public
    def self.descendants
      @descendants ||= []
    end

    # Adds descendant to descendants array and inherits default options
    #
    # @param [Class]
    #
    # @return [Class]
    #
    # @api private
    def self.inherited(descendant)
      descendants << descendant
      descendant.accepted_options.concat(accepted_options)
      options.each { |key, value| descendant.send(key, value) }
      descendant
    end

    # Returns name of the attribute
    #
    # @example
    #   User.attributes[:age].name # => :age
    #
    # @return [Symbol]
    #
    # @api public
    attr_reader :name

    # Returns primitive class of the attribute
    #
    # @return [Class]
    #
    # @api private
    attr_reader :primitive

    # Returns options hash for the attribute
    #
    # @return [Hash]
    #
    # @api private
    attr_reader :options

    # Returns instance variable name of the attribute
    #
    # @return [String]
    #
    # @api private
    attr_reader :instance_variable_name

    # Returns reader visibility
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :reader_visibility


    # Returns write visibility
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :writer_visibility

    DEFAULT_ACCESSOR = :public.freeze

    OPTIONS = [ :primitive, :complex, :accessor, :reader, :writer ].freeze

    accept_options *OPTIONS

    # Initializes an attribute instance
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Hash] options
    #   hash of extra options which overrides defaults set on an attribute class
    #
    # @api private
    def initialize(name, options = {})
      @name    = name
      @options = self.class.options.merge(options).freeze

      @primitive = @options[:primitive].freeze

      @instance_variable_name = "@#{@name}".freeze

      default_accessor   = @options.fetch(:accessor, DEFAULT_ACCESSOR)
      @reader_visibility = @options.fetch(:reader, default_accessor)
      @writer_visibility = @options.fetch(:writer, default_accessor)
    end

    # Returns if an attribute is a complex one
    #
    # @example
    #   Virtus::Attribute::String.complex? # => false
    #   Virtus::Attribute::Array.complex? # => true
    #
    # @return [TrueClass, FalseClass]
    #
    # @api semipublic
    def complex?
      options[:complex]
    end

    # Returns if the given value's class is an attribute's primitive
    #
    # @return [TrueClass, FalseClass]
    #
    # @api private
    def primitive?(value)
      value.kind_of?(primitive)
    end

    # Converts the given value to the primitive type
    #
    # @param [Object] value
    #   the value
    #
    # @return [Object]
    #   nil, original value or value converted to the primitive type
    #
    # @api private
    def typecast(value)
      if value.nil? || primitive?(value)
        value
      else
        typecast_to_primitive(value)
      end
    end

    # Converts the given value to the primitive type
    #
    # @api private
    def typecast_to_primitive(value)
      value
    end

    # Returns value of an attribute for the given instance
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api private
    def get(instance)
      get!(instance)
    end

    # Returns the instance variable of the attribute
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api private
    def get!(instance)
      instance.instance_variable_get(instance_variable_name)
    end

    # Sets the value on the instance
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api private
    def set(instance, value)
      set!(instance, typecast(value)) unless value.nil?
    end

    # Sets instance variable of the attribute
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api private
    def set!(instance, value)
      instance.instance_variable_set(instance_variable_name, value)
    end

    # Creates an attribute reader method
    #
    # @return [NilClass]
    #
    # @api private
    def add_reader_method(model)
      model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        chainable(:attribute) do
          #{reader_visibility}

          def #{name}
            return #{instance_variable_name} if defined?(#{instance_variable_name})
            attribute = self.class.attributes[#{name.inspect}]
            #{instance_variable_name} = attribute ? attribute.get(self) : nil
          end
        end
      RUBY
    end

    # Creates an attribute writer method
    #
    # @return [NilClass]
    #
    # @api private
    def add_writer_method(model)
      model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        chainable(:attribute) do
          #{writer_visibility}

          def #{name}=(value)
            self.class.attributes[#{name.inspect}].set(self, value)
          end
        end
      RUBY
    end
  end # Attribute
end # Virtus
