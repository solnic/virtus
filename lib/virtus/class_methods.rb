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

    # Hook called when virtus is subclassed
    #
    # @param [Class] descendant
    #
    # @return [undefined]
    #
    # @api private
    def inherited(descendant)
      super
      # Create a descendant specific AttributeMethods module to make 
      # sure getters and setters are overriden and not redefined.
      descendant_mod_with_methods.send(:include,self::AttributeMethods)
      descendant.const_set(:AttributeMethods,descendant_mod_with_methods)
    end
   
    private_class_method :inherited

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
    # @see Attribute.build
    #
    # @api public
    def attribute(*args)
      attribute = Attribute.build(*args)
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
      return @attributes if defined?(@attributes)
      superclass = self.superclass
      method     = __method__
      parent     = superclass.send(method) if superclass.respond_to?(method)
      @attributes = AttributeSet.new(parent)
    end

  protected

    # Set up the anonymous module which will host Attribute accessor methods
    #
    # @return [self]
    #
    # @api private
    def virtus_setup_attributes_accessor_module
      @virtus_attributes_accessor_module = AttributesAccessor.new(inspect)
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
