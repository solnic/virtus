module Virtus
  class Attribute
    attr_reader :name, :primitive, :options, :instance_variable_name,
      :reader_visibility, :writer_visibility

    OPTIONS = [ :primitive, :complex, :accessor, :reader, :writer ].freeze

    DEFAULT_ACCESSOR = :public

    class << self
      # Returns an array of valid options
      #
      # @return [Array]
      #   the array of valid option names
      #
      # @api public
      def accepted_options
        @accepted_options ||= []
      end

      # Defines which options are valid for a given attribute class.
      #
      # Example:
      #
      #   class MyAttribute < Virtus::Attributes::Object
      #     accept_options :foo, :bar
      #   end
      #
      # @api public
      def accept_options(*args)
        accepted_options.concat(args)

        # create methods for each new option
        args.each { |option| add_option_method(option) }

        # add new options to all descendants
        descendants.each { |descendant| descendant.accepted_options.concat(args) }
      end

      # @api private
      def add_option_method(option)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{option}(value = Undefined)          # def self.unique(value = Undefined)
            return @#{option} if value.equal?(Undefined) #   return @unique if value.equal?(Undefined)
            @#{option} = value                           #   @unique = value
          end                                            # end
        RUBY
      end

      # Returns all the descendant classes
      #
      # @return [Array]
      #   the array of descendants
      #
      # @api public
      def descendants
        @descendants ||= []
      end

      # Returns default options hash for a give attribute class.
      #
      # @return [Hash]
      #   a hash of default option values
      #
      # @api public
      def options
        options = {}
        accepted_options.each do |method|
          value = send(method)
          options[method] = value unless value.nil?
        end
        options
      end

      # Adds descendant to descendants array and inherits default options
      #
      # @api private
      def inherited(descendant)
        descendants << descendant
        descendant.accepted_options.concat(accepted_options)
        options.each { |key, value| descendant.send(key, value) }
      end
    end

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

    # Returns if an attribute is a complex one.
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

    # Converts the given value to the primitive type unless it's already
    # the primitive or nil
    #
    # @param [Object] value
    #   the value
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
    # @api private
    def get(instance)
      get!(instance)
    end

    # Returns the instance variable of the attribute
    #
    # @api private
    def get!(instance)
      instance.instance_variable_get(instance_variable_name)
    end

    # Sets the value on the instance
    #
    # @api private
    def set(instance, value)
      set!(instance, typecast(value)) unless value.nil?
    end

    # Sets instance variable of the attribute
    #
    # @api private
    def set!(instance, value)
      instance.instance_variable_set(instance_variable_name, value)
    end

    # Creates an attribute reader method
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
