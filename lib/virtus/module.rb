module Virtus

  # Virtus module class that can define attributes for later inclusion
  #
  module Module

    def included(model)
      model.send(:include, Virtus)
      define_attributes(model)
    end

    def attribute(*args)
      attribute_definitions << args
    end

  private

    def attribute_definitions
      @_attribute_definitions ||= []
    end

    def define_attributes(model)
      attribute_definitions.reverse.each do |attribute_args|
        model.attribute(*attribute_args)
      end
    end

  end # class Module
end # module Virtus
