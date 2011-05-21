module Virtus
  module Attributes
    class << self
      # @api semipublic
      # TODO: document
      def determine_type(class_or_name)
        if class_or_name.is_a?(Class) && class_or_name < Attributes::Object
          class_or_name
        elsif const_defined?(name = class_or_name.to_s)
          const_get(name)
        end
      end
    end

    # @api public
    # TODO: document
    def attribute(name, type, options = {})
      attribute_klass  = Attributes.determine_type(type)
      attributes[name] = attribute_klass.new(name, self, options)
    end

    # @api public
    # TODO: document
    def attributes
      @attributes ||= {}
    end

    private

    # @api private
    # TODO: document
    def const_missing(name)
      Attributes.determine_type(name) || super
    end
  end # Attributes
end # Virtus
