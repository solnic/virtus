module Virtus
  class Attribute
    class Accessor

      class Builder

        def self.call(*args)
          builder = new(*args)
          builder.accessor
        end

        def initialize(name, type, options = {})
          @name       = name
          @type       = type
          @options    = options
          @primitive  = options.fetch(:primitive, ::Object)
          @visibility = determine_visibility
        end

        def accessor
          accessor_class.new(reader, writer)
        end

        def accessor_class
          @options[:lazy] ? Accessor::LazyAccessor : Accessor
        end

        def reader
          reader_class.new(@name, reader_options)
        end

        def writer
          writer_class.new(@name, writer_options)
        end

        def reader_class
          @options.fetch(:reader_class) {
            @type.reader_class(@primitive, @options)
          }
        end

        def writer_class
          @options.fetch(:writer_class) {
            @type.writer_class(@primitive, @options)
          }
        end

        def reader_options
          @type.reader_options(@options).update(:visibility => @visibility[:reader])
        end

        def writer_options
          @type.writer_options(@options).update(:visibility => @visibility[:writer])
        end

        private

        def determine_visibility
          default_accessor  = @options.fetch(:accessor, :public)
          reader_visibility = @options.fetch(:reader, default_accessor)
          writer_visibility = @options.fetch(:writer, default_accessor)
          { :reader => reader_visibility, :writer => writer_visibility }
        end

      end # class Builder

    end # class Accessor
  end # class Attribute
end # module Virtus
