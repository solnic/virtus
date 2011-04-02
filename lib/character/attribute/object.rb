module Character
  module Attribute
    class Object
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
        end
      end

      attr_reader :name, :model, :options, :instance_variable_name,
        :reader_visibility, :writer_visibility

      OPTIONS = [ :accessor, :reader, :writer ].freeze

      accept_options :load_as, :dump_as, *OPTIONS

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

      private

      def _create_reader(name)
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          #{reader_visibility}
          def #{name}
            return #{instance_variable_name} if defined?(#{instance_variable_name})
            attribute = attribute[#{name.inspect}]
            #{instance_variable_name} = attribute ? attribute.get(self) : nil
          end
        RUBY
      end

      def _create_writer(name)
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          #{writer_visibility}
          def #{name}=(value)
            attribute = attributes[#{name.inspect}]
            attribute.set(value, self)
          end
        RUBY
      end
    end # Object
  end # Attribute
end # Character
