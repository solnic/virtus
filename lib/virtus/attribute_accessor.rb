module Virtus
  class AttributeAccessor < Module
    attr_reader :inspect

    def initialize(name)
      super
      @inspect = "#{name}::AttributeAccessor"
    end

    def define_accessor_for(attribute)
      define_reader_method(attribute)
      define_writer_method(attribute)

      self
    end

    # Creates an attribute reader method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_reader_method(attribute)
      reader_method_name = attribute.name

      define_method(reader_method_name) { attribute.get(self) }
      send(reader_visibility, reader_method_name)
    end

    # Creates an attribute writer method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_writer_method(attribute)
      writer_method_name = "#{attribute.name}="

      define_method(writer_method_name) { |value| attribute.set(self, value) }
      send(writer_visibility, writer_method_name)
    end

  end
end
