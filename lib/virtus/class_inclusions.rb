module Virtus

  # Class-level extensions
  module ClassInclusions

    # Extends a descendant with class and instance methods
    #
    # @param [Class] descendant
    #
    # @return [undefined]
    #
    # @api private
    def self.included(descendant)
      super
      descendant.extend(ClassMethods)
      descendant.class_eval { include InstanceMethods }
    end
    private_class_method :included

  private

    # Return class' attribute set
    #
    # @return [Virtus::AttributeSet]
    #
    # @api private
    def attribute_set
      self.class.attribute_set
    end

    # Return a list of allowed writer method names
    #
    # @return [Set]
    #
    # @api private
    def allowed_writer_methods
      self.class.allowed_writer_methods
    end

  end # module ClassInclusions
end # module Virtus
