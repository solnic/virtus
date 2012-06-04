module Virtus

  # Virtus module class that can define attributes for later inclusion
  #
  module ModuleExtensions

    def extended(object)
      object.extend(Virtus)
      define_attributes(object)
    end

    def included(object)
      object.send(:include, ClassInclusions)
      define_attributes(object)
    end

    def attribute(*args)
      attribute_definitions << args
    end

  private

    def attribute_definitions
      @_attribute_definitions ||= []
    end

    def define_attributes(object)
      attribute_definitions.each do |attribute_args|
        object.attribute(*attribute_args)
      end
    end

  end # class Module
end # module Virtus
