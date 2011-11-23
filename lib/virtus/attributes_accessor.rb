module Virtus
  class AttributesAccessor < Module
    attr_reader :inspect

    # Initialize an AttributesAccessor module,
    #   for hosting Attribute access methods
    #
    # @param [Symbol, String] name
    #
    # @api private
    def initialize(name)
      super()
      @inspect = "#{name}::AttributesAccessor"
    end

    # Define reader and writer methods for an Attribute
    #
    # @param [Attribute] attribute
    #
    # @return [self]
    #
    # @api private
    def define_attribute_accessor(attribute)
      attribute.define_reader_method(self)
      attribute.define_writer_method(self)

      self
    end

    # Defines an attribute reader method
    #
    # @param [Attribute] attribute
    # @param [Symbol, String] method_name
    # @param [Symbol, String] visibility
    #
    # @return [self]
    #
    # @api private
    def define_reader_method(attribute, method_name, visibility)
      define_method(method_name) { attribute.get(self) }
      send(visibility, method_name)
      self
    end

    # Defines an attribute writer method
    #
    # @param [Attribute] attribute
    # @param [Symbol, String] method_name
    # @param [Symbol, String] visibility
    #
    # @return [self]
    #
    # @api private
    def define_writer_method(attribute, method_name, visibility)
      define_method(method_name) { |value| attribute.set(self, value) }
      send(visibility, method_name)
      self
    end

  end
end
