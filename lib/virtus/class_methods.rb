module Virtus

  # Class methods that are added when you include Virtus
  module ClassMethods
    include Extensions::Methods
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
      descendant.send(:include, AttributeSet.create(descendant))
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
      @attribute_set
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
      AttributeSet.create(descendant)
      descendant.module_eval { include attribute_set }
    end

    # The list of allowed public methods
    #
    # @return [Array<String>]
    #
    # @api private
    def allowed_methods
      public_instance_methods.map(&:to_s)
    end

    # @api private
    def assert_valid_name(name)
      if instance_methods.include?(:attributes) && name.to_sym == :attributes
        raise ArgumentError, "#{name.inspect} is not allowed as an attribute name"
      end
    end

  end # module ClassMethods
end # module Virtus
