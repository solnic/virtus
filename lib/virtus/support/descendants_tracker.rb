module Virtus

  # A module that adds descendant tracking to a class
  module DescendantsTracker

    # Hook called when class is inherited
    #
    # @param [Class] descendant
    #
    # @return [self]
    #
    # @api private
    def inherited(descendant)
      superclass = self.superclass
      superclass.inherited(descendant) if superclass.respond_to?(:descendants)
      descendants.unshift(descendant)
      self
    end

    # Return the descendants of this class
    #
    # @return [Array<Class>]
    #
    # @api private
    def descendants
      @descendants ||= []
    end

  end # module DescendantsTracker
end # module Virtus
