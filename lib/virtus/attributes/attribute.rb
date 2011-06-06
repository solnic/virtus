module Virtus
  module Attributes
    class Attribute
      attr_reader :name, :model, :options, :instance_variable_name,
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
          args.each do |attribute_option|
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def self.#{attribute_option}(value = Undefined)          # def self.unique(value = Undefined)
              return @#{attribute_option} if value.equal?(Undefined) #   return @unique if value.equal?(Undefined)
              @#{attribute_option} = value                           #   @unique = value
            end                                                      # end
            RUBY
          end

          descendants.each { |descendant| descendant.accepted_options.concat(args) }
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

      # Returns if an attribute is a complex one.
      #
      # @return [TrueClass, FalseClass]
      #
      # @api semipublic
      def complex?
        options[:complex]
      end

      # Initializes an attribute instance
      #
      # @param [Symbol] name
      #   the name of an attribute
      #
      # @param [Class] model
      #   the object's class
      #
      # @param [Hash] options
      #   hash of extra options which overrides defaults set on an attribute class
      #
      # @api private
      def initialize(name, model, options = {})
        @name    = name
        @model   = model
        @options = self.class.options.merge(options).freeze

        @instance_variable_name = "@#{@name}".freeze

        default_accessor   = @options.fetch(:accessor, DEFAULT_ACCESSOR)
        @reader_visibility = @options.fetch(:reader, default_accessor)
        @writer_visibility = @options.fetch(:writer, default_accessor)

        _create_reader
        _create_writer
      end

      # Returns if the given value's class is an attribute's primitive
      #
      # @return [TrueClass, FalseClass]
      #
      # @api private
      def primitive?(value)
        value.kind_of?(self.class.primitive)
      end

      # Converts the given value to the primitive type unless it's already
      # the primitive or nil
      #
      # @param [Object] value
      #   the value
      #
      # @api private
      def typecast(value, model = nil)
        if value.nil? || primitive?(value)
          value
        else
          typecast_to_primitive(value)
        end
      end

      # Converts the given value to the primitive type
      #
      # @api private
      def typecast_to_primitive(value, model)
        value
      end

      # Returns value of an attribute for the given model
      #
      # @api private
      def get(model)
        get!(model)
      end

      # Returns the instance variable of the attribute
      #
      # @api private
      def get!(model)
        model.instance_variable_get(instance_variable_name)
      end

      # Sets the value on the model
      #
      # @api private
      def set(model, value)
        return if value.nil?
        set!(model, typecast(value, model))
      end

      # Sets instance variable of the attribute
      #
      # @api private
      def set!(model, value)
        model.instance_variable_set(instance_variable_name, value)
      end

      # Creates an attribute reader method
      #
      # @api private
      def _create_reader
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
      def _create_writer
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
  end # Attributes
end # Virtus
