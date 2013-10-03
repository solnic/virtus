module Virtus

  # Extensions common for both classes and instances
  module Extensions
    WRITER_METHOD_REGEXP   = /=\z/.freeze
    INVALID_WRITER_METHODS = %w[ == != === []= attributes= ].to_set.freeze
    RESERVED_NAMES         = [:attributes].to_set.freeze

    # A hook called when an object is extended with Virtus
    #
    # @param [Object] object
    #
    # @return [undefined]
    #
    # @api private
    def self.extended(object)
      super
      object.instance_eval do
        extend Methods
        extend InstanceMethods
        extend AllowedWriterMethods
        extend InstanceMethods::MassAssignment
      end
    end
    private_class_method :extended

    module Methods

      # @api private
      def self.extended(descendant)
        super
        descendant.extend(AttributeSet.create(descendant))
      end
      private_class_method :extended

      # Defines an attribute on an object's class or instance
      #
      # @example
      #    class Book
      #      include Virtus.model
      #
      #      attribute :title,        String
      #      attribute :author,       String
      #      attribute :published_at, DateTime
      #      attribute :page_count,   Integer
      #      attribute :index                   # defaults to Object
      #    end
      #
      # @param [Symbol] name
      #   the name of an attribute
      #
      # @param [Class,Array,Hash,Axiom::Types::Type,String,Symbol] type
      #   the type class of an attribute
      #
      # @param [#to_hash] options
      #   the extra options hash
      #
      # @return [self]
      #
      # @see Attribute.build
      #
      # @api public
      def attribute(name, type = nil, options = {})
        assert_valid_name(name)
        attribute_set << Attribute.build(type, options.merge(:name => name))
        self
      end

      # @see Virtus.default_value
      #
      # @api public
      def values(&block)
        private :attributes= if instance_methods.include?(:attributes=)
        yield
        include(::Equalizer.new(*attribute_set.map(&:name)))
      end

      private

      # Return an attribute set for that instance
      #
      # @return [AttributeSet]
      #
      # @api private
      def attribute_set
        @attribute_set
      end

    end # Methods

    module AllowedWriterMethods
      WRITER_METHOD_REGEXP   = /=\z/.freeze
      INVALID_WRITER_METHODS = %w[ == != === []= attributes= ].to_set.freeze

      # The list of writer methods that can be mass-assigned to in #attributes=
      #
      # @return [Set]
      #
      # @api private
      def allowed_writer_methods
        @allowed_writer_methods ||=
          begin
            allowed_writer_methods  = allowed_methods.grep(WRITER_METHOD_REGEXP).to_set
            allowed_writer_methods -= INVALID_WRITER_METHODS
            allowed_writer_methods.freeze
          end
      end

    end # AllowedWriterMethods

  end # module Extensions

end # module Virtus
