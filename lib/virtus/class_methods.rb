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
        virtus_setup_attributes_accessor_module
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
      attribute = Attribute.build(name, type, options)
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

  protected

    # Set up the anonymous module which will host Attribute accessor methods
    #
    # @return [self]
    #
    # @api private
    def virtus_setup_attributes_accessor_module
      @virtus_attributes_accessor_module = AttributesAccessor.new(name || inspect)
      include virtus_attributes_accessor_module

      self
    end

  private

    # Setup descendants' own Attribute-accessor-method-hosting modules
    #
    # Descendants inherit Attribute accessor methods via Ruby's inheritance
    # mechanism: Attribute accessor methods are defined in a module included
    # in a superclass. Attributes defined on descendants add methods to the
    # descendant's Attributes accessor module, leaving the superclass's method
    # table unaffected.
    #
    # @param [Class] descendant
    #
    # @return [undefined]
    #
    # @api private
    def inherited(descendant)
      super

      descendant.virtus_setup_attributes_accessor_module
    end

    # Holds the anonymous module which hosts this class's Attribute accessors
    #
    # @return [Module]
    #
    # @api private
    attr_reader :virtus_attributes_accessor_module

    # Hooks into const missing process to determine types of attributes
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
