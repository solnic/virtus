module Virtus

  # Class methods that are added when you include Virtus
  module ClassMethods

    # Hook called when module is extended
    #
    # @param [Class] descendant
    #
    # @return [undefined]
    #
    # @api private
    def self.extended(descendant)
      super

      descendant.module_eval do
        extend DescendantsTracker
        include virtus_attributes_accessor_module
      end
    end

    private_class_method :extended

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
      include virtus_attributes_accessor_module
      attribute.define_accessor_methods(virtus_attributes_accessor_module)
      virtus_add_attribute(attribute)
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
    #   User.attributes  # =>
    #
    #   TODO: implement inspect so the output is not cluttered - solnic
    #
    # @return [AttributeSet]
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

    def virtus_attributes_accessor_module
      @virtus_attributes_accessor_module ||= AttributesAccessor.new(name)
    end

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

    # Add the attribute to the class' and descendants' attributes
    #
    # @param [Attribute]
    #
    # @return [undefined]
    #
    # @api private
    def virtus_add_attribute(attribute)
      attributes << attribute
      descendants.each { |descendant| descendant.attributes.reset }
    end

  end # module ClassMethods
end # module Virtus
