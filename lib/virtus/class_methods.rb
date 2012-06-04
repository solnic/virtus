module Virtus

  # Class methods that are added when you include Virtus
  module ClassMethods
    include InstanceExtensions

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
      superclass  = self.superclass
      method      = __method__
      parent      = superclass.public_send(method) if superclass.respond_to?(method)
      @attributes = AttributeSet.new(parent)
    end
    alias _attributes attributes

  protected

    # Set up the anonymous module which will host Attribute accessor methods
    #
    # @return [self]
    #
    # @api private
    def virtus_setup_attributes_accessor_module
      @virtus_attributes_accessor_module = AttributesAccessor.new(inspect)
      include @virtus_attributes_accessor_module
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

    # Hooks into const missing process to determine types of attributes
    #
    # @param [String] name
    #
    # @return [Class]
    #
    # @api private
    def const_missing(name)
      Attribute.determine_type(name) or super
    end

    # Add the attribute to the class' and descendants' attributes
    #
    # @param [Attribute]
    #
    # @return [undefined]
    #
    # @api private
    def virtus_add_attribute(attribute)
      super
      descendants.each { |descendant| descendant.attributes.reset }
    end

    def public_method_list
      public_instance_methods
    end

  end # module ClassMethods
end # module Virtus
