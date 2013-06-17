module Virtus

  # Class methods that are added when you include Virtus
  module ClassMethods
    include Extensions
    include ConstMissingExtensions

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
        include attribute_set
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
    #   User.attribute_set  # =>
    #
    #   TODO: implement inspect so the output is not cluttered - solnic
    #
    # @return [AttributeSet]
    #
    # @api public
    def attribute_set
      return @attribute_set if defined?(@attribute_set)
      superclass  = self.superclass
      method      = __method__
      parent      = superclass.public_send(method) if superclass.respond_to?(method)
      @attribute_set = AttributeSet.new(parent)
    end

    # @see Virtus::ClassMethods.attribute_set
    #
    # @deprecated
    #
    # @api public
    def attributes
      warn "#{self}.attributes is deprecated. Use #{self}.attribute_set instead: #{caller.first}"
      attribute_set
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
      descendant.module_eval { include attribute_set }
    end

    # Add the attribute to the class' and descendants' attributes
    #
    # @param [Attribute] attribute
    #
    # @return [undefined]
    #
    # @api private
    def virtus_add_attribute(attribute)
      super
      descendants.each { |descendant| descendant.attribute_set.reset }
    end

    # The list of allowed public methods
    #
    # @return [Array<String>]
    #
    # @api private
    def allowed_methods
      public_instance_methods.map(&:to_s)
    end

  end # module ClassMethods
end # module Virtus
