module Virtus

  # Virtus module that can define attributes for later inclusion
  #
  module ModuleExtensions

    # Define an attribute in the module
    #
    # @see Virtus::Extensions#attribute
    #
    # @return [self]
    #
    # @api private
    def attribute(*args)
      attribute_definitions << args
      self
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
      object.set_default_attributes
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
      object.module_eval { include Virtus }
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

  end # module ModuleExtensions
end # module Virtus
