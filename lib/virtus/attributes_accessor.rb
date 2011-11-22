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
    # @return [receiver]
    #
    # @api private
    def define_attribute_accessor(attribute)
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
      attribute.reader_method_names.each do |name|
        define_method(name) { attribute.get(self) }
        send(attribute.reader_visibility, name)
      end
    end

    # Creates an attribute writer method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_writer_method(attribute)
      attribute.writer_method_names.each do |name|
        define_method(name) { |value| attribute.set(self, value) }
        send(attribute.writer_visibility, name)
      end
    end

  end
end
