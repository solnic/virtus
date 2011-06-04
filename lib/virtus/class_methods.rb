module Virtus
  module ClassMethods
    # Chains Class.new to be able to set attributes during initialization of
    # an object.
    #
    # @param [Hash] attributes
    #   the attributes hash to be set
    #
    # @return [Object]
    #
    # @api private
    def new(attributes = {})
      model = super
      model.attributes = attributes
      model
    end

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
      attribute_klass  = Virtus.determine_type(type)
      attributes[name] = attribute_klass.new(name, self, options)
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
