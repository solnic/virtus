module Virtus

  # Abstract class implementing base API for attribute types
  #
  # @abstract
  class Attribute
    extend DescendantsTracker

    # Returns a Virtus::Attribute::Object descendant based on a name or class
    #
    # @example
    #   Attribute.determine_type('String')  # => Virtus::Attribute::String
    #
    # @param [Class, #to_s] class_or_name
    #   name of a class or a class itself
    #
    # @return [Class]
    #   one of the Virtus::Attribute::Object descendants
    #
    # @return [nil]
    #   nil if the type cannot be determined by the class_or_name
    #
    # @api public
    def self.determine_type(class_or_name)
      # first match on the Attribute singleton class first, then match
      # any class, finally fallback to matching on the string
      case class_or_name
      when Attribute::Object.singleton_class then determine_type_from_attribute(class_or_name)
      when Class                             then determine_type_from_primitive(class_or_name)
      else
        determine_type_from_string(class_or_name.to_s)
      end
    end

    # Return the Attribute class given an Attribute descendant
    #
    # @param [Class<Attribute>] attribute
    #
    # @return [Class<Attribute>]
    #
    # @api private
    def self.determine_type_from_attribute(attribute)
      attribute
    end

    private_class_method :determine_type_from_attribute

    # Return the Attribute class given a primitive
    #
    # @param [Class] primitive
    #
    # @return [Class<Attribute>]
    #
    # @return [nil]
    #   nil if the type cannot be determined by the primitive
    #
    # @api private
    def self.determine_type_from_primitive(primitive)
      descendants.detect { |descendant| primitive <= descendant.primitive }
    end

    private_class_method :determine_type_from_primitive

    # Return the Attribute class given a string
    #
    # @param [String] string
    #
    # @return [Class<Attribute>]
    #
    # @return [nil]
    #   nil if the type cannot be determined by the string
    #
    # @api private
    def self.determine_type_from_string(string)
      const_get(string) if const_defined?(string)
    end

    private_class_method :determine_type_from_string

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
      accepted_options.each do |option_name|
        option_value         = send(option_name)
        options[option_name] = option_value unless option_value.nil?
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
    def self.accept_options(*new_options)
      add_accepted_options(new_options)
      new_options.each { |option| define_option_method(option) }
      descendants.each { |descendant| descendant.add_accepted_options(new_options) }
      self
    end

    # Adds a reader/writer method for the give option name
    #
    # @return [undefined]
    #
    # @api private
    def self.define_option_method(option)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{option}(value = Undefined)           # def self.primitive(value = Undefined)
          return @#{option} if value.equal?(Undefined)  #   return @primitive if value.equal?(Undefined)
          @#{option} = value                            #   @primitive = value
        end                                             # end
      RUBY
    end

    private_class_method :define_option_method

    # Sets default options
    #
    # @param [#to_hash] new_options
    #   options to be set
    #
    # @return [self]
    #
    # @api private
    def self.set_options(new_options)
      new_options.to_hash.each do |option_name, option_value|
        send(option_name, option_value)
      end
      self
    end

    # Adds new options that an attribute class can accept
    #
    # @param [#to_ary] new_options
    #   new options to be added
    #
    # @return [self]
    #
    # @api private
    def self.add_accepted_options(new_options)
      accepted_options.concat(new_options.to_ary)
      self
    end

    # Adds descendant to descendants array and inherits default options
    #
    # @param [Class] descendant
    #
    # @return [undefined]
    #
    # @api private
    def self.inherited(descendant)
      super
      descendant.add_accepted_options(accepted_options).set_options(options)
    end

    private_class_method :inherited

    # Returns if the given value's class is an attribute's primitive
    #
    # @example
    #   Virtus::Attribute::String.primitive?('String')  # => true
    #
    # @return [Boolean]
    #
    # @api public
    def self.primitive?(value)
      value.kind_of?(primitive)
    end

    # Returns name of the attribute
    #
    # @example
    #   User.attributes[:age].name  # => :age
    #
    # @return [Symbol]
    #
    # @api public
    attr_reader :name

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

    # Returns method name that should be used for typecasting
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :typecast_method

    DEFAULT_ACCESSOR = :public

    OPTIONS = [ :primitive, :complex, :accessor, :reader, :writer, :typecast_method ].freeze

    accept_options *OPTIONS

    # Initializes an attribute instance
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [#to_hash] options
    #   hash of extra options which overrides defaults set on an attribute class
    #
    # @return [undefined]
    #
    # @api private
    def initialize(name, options = {})
      @name    = name
      @options = self.class.options.merge(options.to_hash).freeze

      @instance_variable_name = "@#{@name}".freeze
      @typecast_method        = @options.fetch(:typecast_method)
      @complex                = @options.fetch(:complex, false)

      set_visibility
    end

    # Returns if an attribute is a complex one
    #
    # @example
    #   Virtus::Attribute::String.complex?  # => false
    #   Virtus::Attribute::Array.complex?   # => true
    #
    # @return [Boolean]
    #
    # @api public
    def complex?
      @complex
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
      Typecast.const_get(value.class.name).send(typecast_method, value)
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
      unless value.nil?
        set!(instance, self.class.primitive?(value) ? value : typecast(value))
      end
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
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_reader_method(mod)
      reader_method_name = name
      attribute          = self

      mod.send(:define_method,    reader_method_name) { attribute.get(self) }
      mod.send(reader_visibility, reader_method_name)

      self
    end

    # Creates an attribute writer method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_writer_method(mod)
      writer_method_name = "#{name}="
      attribute          = self

      mod.send(:define_method,    writer_method_name) { |value| attribute.set(self, value) }
      mod.send(writer_visibility, writer_method_name)

      self
    end

  private

    # Sets visibility of reader/write methods based on the options hash
    #
    # @return [undefined]
    #
    # @api private
    def set_visibility
      default_accessor   = @options.fetch(:accessor, self.class::DEFAULT_ACCESSOR)
      @reader_visibility = @options.fetch(:reader, default_accessor)
      @writer_visibility = @options.fetch(:writer, default_accessor)
    end

  end # class Attribute
end # module Virtus
