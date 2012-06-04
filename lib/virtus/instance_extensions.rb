module Virtus

  # Instance-level extensions
  module InstanceExtensions
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
            allowed_writer_methods  = public_method_list.map(&:to_s)
            allowed_writer_methods  = allowed_writer_methods.grep(WRITER_METHOD_REGEXP).to_set
            allowed_writer_methods -= INVALID_WRITER_METHODS
            allowed_writer_methods.freeze
          end
      end
    end

    def self.extended(object)
      object.extend(AllowedWriterMethods)
      object.extend(InstanceMethods)
      object.instance_eval do
        @virtus_attributes_accessor_module = AttributesAccessor.new(object.class.inspect)
        extend @virtus_attributes_accessor_module
      end
    end

    # Defines an attribute on an object's class
    #
    # @example
    #    class Book
    #      include Virtus
    #
    #      attribute :title,        String
    #      attribute :author,       String
    #      attribute :published_at, DateTime
    #      attribute :page_count,   Integer
    #    end
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Class] type
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
    def attribute(*args)
      attribute = Attribute.build(*args)
      attribute.define_accessor_methods(@virtus_attributes_accessor_module)
      virtus_add_attribute(attribute)
      self
    end

    def _attributes
      @_attributes ||= AttributeSet.new
    end

    def virtus_add_attribute(attribute)
      _attributes << attribute
    end
  end # module InstanceExtensions
end # module Virtus
