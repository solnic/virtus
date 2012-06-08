module Virtus

  # Virtus module that can define attributes for later inclusion
  #
  module ModuleExtensions

    def attribute(*args)
      attribute_definitions << args
    end

  private

    # Extend an object with Virtus methods and define attributes
    #
    # @param [Object] object
    #
    # @return [undefined]
    #
    # @api private
    def extended(object)
      super
      object.extend(Virtus)
      define_attributes(object)
    end

    # Extend a class with Virtus methods and define attributes
    #
    # @param [Object] object
    #
    # @return [undefined]
    #
    # @api private
    def included(object)
      super
      object.send(:include, ClassInclusions)
      define_attributes(object)
    end

    # Return attribute definitions
    #
    # @return [Array<Hash>]
    #
    # @api private
    def attribute_definitions
      @_attribute_definitions ||= []
    end

    # Define attributes on a class or instance
    #
    # @param [Object,Class] object
    #
    # @return [undefined]
    #
    # @api private
    def define_attributes(object)
      attribute_definitions.each do |attribute_args|
        object.attribute(*attribute_args)
      end
    end

  end # class ModuleExtensions
end # module Virtus
