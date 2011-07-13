module Virtus

  # A module that adds descendant tracking to a class
  module DescendantsTracker

    # Return the descendants of this class
    #
    # @return [Array<Class>]
    #
    # @api private
    def descendants
      @descendants ||= []
    end

    # Add the descendant to this class and the superclass
    #
    # @param [Class] descendant
    #
    # @return [self]
    #
    # @api private
    def add_descendant(descendant)
      superclass = self.superclass
      superclass.add_descendant(descendant) if superclass.respond_to?(:add_descendant)
      descendants.unshift(descendant)
      self
    end

  private

    # Hook called when class is inherited
    #
    # @param [Class] descendant
    #
    # @return [undefined]
    #
    # @api private
    def inherited(descendant)
      super
      add_descendant(descendant)
    end

  end # module DescendantsTracker
end # module Virtus
