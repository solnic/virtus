module Virtus

  # Class methods that are added when you include Virtus
  module ClassMethods

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
    # @api public
    def attribute(name, type, options = {})
      attribute = Attribute.determine_type(type).new(name, options)

      attribute.add_reader_method(self)
      attribute.add_writer_method(self)

      attributes << attribute
      descendants.each { |descendant| descendant.attributes.reset }

      self
    end

    # Returns all the attributes defined on a Class
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #     attribute :age,  Integer
    #   end
    #
    #   User.attributes # =>
    #
    #   TODO: implement inspect so the output is not cluttered - solnic
    #
    # @return [Hash]
    #   an attributes hash indexed by attribute names
    #
    # @api public
    def attributes
      @attributes ||= begin
        superclass = self.superclass
        parent     = superclass.attributes if superclass.respond_to?(:attributes)
        AttributeSet.new(parent)
      end
    end

  private

    # Hooks into const missing process to determine types of attributes
    #
    # It is used when an attribute is defined and a global class like String
    # or Integer is provided as the type which needs to be mapped to
    # Virtus::Attribute::String and Virtus::Attribute::Integer
    #
    # @param [String] name
    #
    # @return [Class]
    #
    # @api private
    def const_missing(name)
      Attribute.determine_type(name) || super
    end

  end # module ClassMethods
end # module Virtus
