module Virtus

  # A set of Attribute objects
  class AttributeSet
    include Enumerable

    # Return the parent attributes
    #
    # @return [AttributeSet]
    #   the parent attributes
    #
    # @return [nil]
    #   nil if there are no parent attributes
    #
    # @api private
    attr_reader :parent

    # Initialize an AttributeSet
    #
    # @param [AttributeSet] parent
    # @param [Array] attributes
    #
    # @return [undefined]
    #
    # @api private
    def initialize(parent = nil, attributes = [])
      @parent       = parent
      @attributes   = attributes.dup
      @index        = {}
      @string_index = {}
      reset
    end

    # Iterate over each attribute in the set
    #
    # @example
    #   attribute_set = AttributeSet.new(attributes, parent)
    #   attribute_set.each { |attribute| ... }
    #
    # @yield [attribute]
    #
    # @yieldparam [Attribute] attribute
    #   each attribute in the set
    #
    # @return [self]
    #
    # @api public
    def each
      return to_enum unless block_given?
      @index.each_value { |attribute| yield attribute }
      self
    end

    # Adds the attributes to the set
    #
    # @example
    #   attribute_set.merge(attributes)
    #
    # @param [Array<Attribute>] attributes
    #
    # @return [self]
    #
    # @api public
    def merge(attributes)
      attributes.each { |attribute| self << attribute }
      self
    end

    # Adds an attribute to the set
    #
    # @example
    #   attribute_set << attribute
    #
    # @param [Attribute] attribute
    #
    # @return [self]
    #
    # @api public
    def <<(attribute)
      self[attribute.name] = attribute
      self
    end

    # Get an attribute by name
    #
    # @example
    #   attribute_set[:name]  # => Attribute object
    #
    # @param [Symbol] name
    #
    # @return [Attribute]
    #
    # @api public
    def [](name)
      @index.fetch(name) { @string_index[name] }
    end

    # Set an attribute by name
    #
    # @example
    #   attribute_set[:name] = attribute
    #
    # @param [Symbol] name
    # @param [Attribute] attribute
    #
    # @return [Attribute]
    #
    # @api public
    def []=(name, attribute)
      delete(name)
      @attributes << attribute
      @index[name] = @string_index[name.to_s.freeze] = attribute
    end

    # Reset the index when the parent is updated
    #
    # @return [self]
    #
    # @api private
    def reset
      parent = self.parent
      merge_index(parent) if parent
      merge_index(@attributes)
      self
    end

  private

    # Delete the Attribute by name
    #
    # @param [Symbol] name
    #
    # @return [undefined]
    #
    # @api private
    def delete(name)
      @attributes.delete(@index.delete(name))
      @string_index.delete(name.to_s)
    end

    # Add the attributes to the index
    #
    # @param [Array<Attribute>] attributes
    #
    # @return [undefined]
    #
    # @api private
    def merge_index(attributes)
      attributes.each do |attribute|
        name = attribute.name
        @index[name] = @string_index[name.to_s.freeze] = attribute
      end
    end

  end # class AttributeSet
end # module Virtus
