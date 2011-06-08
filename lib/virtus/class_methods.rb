module Virtus
  module ClassMethods
    # Defines an attribute on an object's class.
    #
    # Usage:
    #
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
    # @param [Hash] options
    #   the extra options hash
    #
    # @return [Virtus::Attributes::Object]
    #
    # @api public
    def attribute(name, type, options = {})
      attribute_klass = Virtus.determine_type(type)
      attribute       = attribute_klass.new(name, options)

      attribute.add_reader_method(self)
      attribute.add_writer_method(self)

      attributes[name] = attribute
    end

    # Returns all the attributes defined on a Class.
    #
    # @return [Hash]
    #   an attributes hash indexed by attribute names
    #
    # @api public
    def attributes
      @attributes ||= {}
    end

    private

    # Hooks into const missing process to determine types of attributes.
    #
    # It is used when an attribute is defined and a global class like String
    # or Integer is provided as the type which needs to be mapped to
    # Virtus::Attributes::String and Virtus::Attributes::Integer.
    #
    # @param [String] name
    #
    # @return [Class]
    #
    # @api private
    def const_missing(name)
      Virtus.determine_type(name) || super
    end
  end # ClassMethods
end # Virtus
