module Character
  module Attributes
    class << self
      # @api semipublic
      # TODO: document
      def determine_type(type)
        const_get(type.to_s.to_sym)
      end
    end

    # @api public
    # TODO: document
    def attribute(name, type, options = {})
      attributes[name] = Attributes.determine_type(type).new(name, self, options)
    end

    # @api public
    # TODO: document
    def attributes
      @attributes ||= {}
    end
  end # Attributes
end # Character
