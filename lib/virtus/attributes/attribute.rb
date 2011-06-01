module Virtus
  module Attributes
    class Attribute
      attr_reader :name, :model, :options, :instance_variable_name,
        :reader_visibility, :writer_visibility

      OPTIONS = [ :primitive, :complex, :accessor, :reader, :writer ].freeze

      DEFAULT_ACCESSOR = :public.freeze

      class << self
        # @api public
        def accepted_options
          @accepted_options ||= []
        end

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

        # @api public
        def descendants
          @descendants ||= []
        end

        # @api public
        def options
          options = {}
          accepted_options.each do |method|
            value = send(method)
            options[method] = value unless value.nil?
          end
          options
        end

        # @api private
        def inherited(descendant)
          descendants << descendant
          descendant.accepted_options.concat(accepted_options)
          options.each { |key, value| descendant.send(key, value) }
        end
      end

      accept_options *OPTIONS

      # @api semipublic
      # TODO: document
      def complex?
        options[:complex]
      end

      def initialize(name, model, options = {})
        @name    = name
        @model   = model
        @options = self.class.options.merge(options).freeze

        @instance_variable_name = "@#{@name}".freeze

        default_accessor   = @options.fetch(:accessor, DEFAULT_ACCESSOR)
        @reader_visibility = @options.fetch(:reader, default_accessor)
        @writer_visibility = @options.fetch(:writer, default_accessor)
      end

      # @api private
      def primitive?(value)
        value.kind_of?(self.class.primitive)
      end

      # @api private
      def typecast(value, model = nil)
        if value.nil? || primitive?(value)
          value
        else
          typecast_to_primitive(value)
        end
      end

      # @api private
      def typecast_to_primitive(value, model)
        value
      end

      # @api private
      def get(model)
        get!(model)
      end

      # @api private
      def get!(model)
        model.instance_variable_get(instance_variable_name)
      end

      # @api private
      def set(model, value)
        return if value.nil?
        set!(model, primitive?(value) ? value : typecast(value, model))
      end

      # @api private
      def set!(model, value)
        model.instance_variable_set(instance_variable_name, value)
      end
    end # Attribute
  end # Attributes
end # Virtus
