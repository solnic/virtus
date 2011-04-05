module Character
  module Attributes
    class Attribute
      attr_reader :name, :model, :options, :instance_variable_name,
        :reader_visibility, :writer_visibility

      OPTIONS = [ :accessor, :reader, :writer ].freeze

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

        # @api private
        def inherited(descendant)
          descendants << descendant
          descendant.accepted_options.concat(accepted_options)
          options.each { |key, value| descendant.send(key, value) }
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
      end

      accept_options :primitive, *OPTIONS

      def initialize(name, model, options)
        @name    = name
        @model   = model
        @options = options.freeze

        @instance_variable_name = "@#{@name}".freeze

        default_accessor = @options.fetch(:accessor, :public)

        @reader_visibility = @options.fetch(:reader, default_accessor)
        @writer_visibility = @options.fetch(:writer, default_accessor)

        _create_writer(name)
        _create_reader(name)
      end

      # @apit private
      def typecast(value, model)
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
        set!(model, primitive?(value) || value.nil? ? value : typecast(value, model))
      end

      # @api private
      def set!(model, value)
        model.instance_variable_set(instance_variable_name, value)
      end

      private

      def _create_reader(name)
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        #{reader_visibility}
          def #{name}
            return #{instance_variable_name} if defined?(#{instance_variable_name})
            attribute = model.attributes[#{name.inspect}]
          #{instance_variable_name} = attribute ? attribute.get(self) : nil
          end
          RUBY
      end

      def _create_writer(name)
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        #{writer_visibility}
          def #{name}=(value)
            attribute = model.attributes[#{name.inspect}]
            attribute.set(value, self)
          end
        RUBY
      end

    end # Attribute
  end # Attributes
end # Character
