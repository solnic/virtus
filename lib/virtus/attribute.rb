module Virtus

  # Abstract class implementing base API for attribute types
  #
  # @abstract
  class Attribute
    extend DescendantsTracker
    extend TypeLookup

    # Returns default options hash for a given attribute class
    #
    # @example
    #   Virtus::Attribute::String.options
    #   # => {:primitive => String}
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
    #   # => [:primitive, :accessor, :reader, :writer]
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
      new_options.to_hash.each { |pair| send(*pair) }
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

    # Returns method name that should be used for coerceing
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :coercion_method

    DEFAULT_ACCESSOR = :public

    OPTIONS = [ :primitive, :accessor, :reader, :writer, :coercion_method ].freeze

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
      @coercion_method        = @options.fetch(:coercion_method)

      set_visibility
    end

    # Returns value of an attribute for the given instance
    #
    # @example
    #   attribute.get(instance)  # => value
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api public
    def get(instance)
      get!(instance)
    end

    # Returns the instance variable of the attribute
    #
    # @example
    #   attribute.get!(instance)  # => value
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api public
    def get!(instance)
      instance.instance_variable_get(instance_variable_name)
    end

    # Sets the value on the instance
    #
    # @example
    #   attribute.set(instance, value)  # => value
    #
    # @return [self]
    #
    # @api public
    def set(instance, value)
      set!(instance, coerce(value))
    end

    # Sets instance variable of the attribute
    #
    # @example
    #   attribute.set!(instance, value)  # => value
    #
    # @return [self]
    #
    # @api public
    def set!(instance, value)
      instance.instance_variable_set(instance_variable_name, value)
    end

    # Converts the given value to the primitive type
    #
    # @example
    #   attribute.coerce(value)  # => primitive_value
    #
    # @param [Object] value
    #   the value
    #
    # @return [Object]
    #   nil, original value or value converted to the primitive type
    #
    # @api public
    def coerce(value)
      Coercion[value.class].send(coercion_method, value)
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
      @reader_visibility = @options.fetch(:reader,   default_accessor)
      @writer_visibility = @options.fetch(:writer,   default_accessor)
    end

  end # class Attribute
end # module Virtus
