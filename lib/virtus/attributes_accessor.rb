module Virtus
  class AttributesAccessor < Module

    # The inspect value of this Module.
    #   This provides meaningful output when inspecting the ancestors
    #   of a class/module that includes this module
    # 
    # @return [String]
    # 
    # @api public
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
