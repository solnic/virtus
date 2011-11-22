module Virtus
  class AttributesAccessor < Module
    attr_reader :inspect

    def initialize(name)
      super()
      @inspect = "#{name}::AttributesAccessor"
    end

    # Define attribute reader and writer methods
    #
    # @param [Attribute]
    #
    # @return [self]
    #
    # @api private
    def define_attribute_accessor(attribute)
      attribute.define_reader_method(self)
      attribute.define_writer_method(self)

      self
    end

    def define_attribute_getter(attribute, method_name, visibility)
      define_method(method_name) { attribute.get(self) }
      send(visibility, method_name)
    end

    def define_attribute_setter(attribute, method_name, visibility)
      define_method(method_name) { |value| attribute.set(self, value) }
      send(visibility, method_name)
    end

  end
end
