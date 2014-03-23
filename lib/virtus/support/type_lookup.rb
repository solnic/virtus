module Virtus

  # A module that adds type lookup to a class
  module TypeLookup

    TYPE_FORMAT = /\A[A-Z]\w*\z/.freeze

    # Set cache ivar on the model
    #
    # @param [Class] model
    #
    # @return [undefined]
    #
    # @api private
    def self.extended(model)
      model.instance_variable_set('@type_lookup_cache', {})
    end

    # Returns a descendant based on a name or class
    #
    # @example
    #   MyClass.determine_type('String')  # => MyClass::String
    #
    # @param [Class, #to_s] class_or_name
    #   name of a class or a class itself
    #
    # @return [Class]
    #   a descendant
    #
    # @return [nil]
    #   nil if the type cannot be determined by the class_or_name
    #
    # @api public
    def determine_type(class_or_name)
      @type_lookup_cache[class_or_name] ||= determine_type_and_cache(class_or_name)
    end

    # Return the default primitive supported
    #
    # @return [Class]
    #
    # @api private
    def primitive
      raise NotImplementedError, "#{self}.primitive must be implemented"
    end

  private

    # @api private
    def determine_type_and_cache(class_or_name)
      case class_or_name
      when singleton_class
        determine_type_from_descendant(class_or_name)
      when Class
        determine_type_from_primitive(class_or_name)
      else
        determine_type_from_string(class_or_name.to_s)
      end
    end

    # Return the class given a descendant
    #
    # @param [Class] descendant
    #
    # @return [Class]
    #
    # @api private
    def determine_type_from_descendant(descendant)
      descendant if descendant < self
    end

    # Return the class given a primitive
    #
    # @param [Class] primitive
    #
    # @return [Class]
    #
    # @return [nil]
    #   nil if the type cannot be determined by the primitive
    #
    # @api private
    def determine_type_from_primitive(primitive)
      type = nil
      descendants.select(&:primitive).reverse_each do |descendant|
        descendant_primitive = descendant.primitive
        next unless primitive <= descendant_primitive
        type = descendant if type.nil? or type.primitive > descendant_primitive
      end
      type
    end

    # Return the class given a string
    #
    # @param [String] string
    #
    # @return [Class]
    #
    # @return [nil]
    #   nil if the type cannot be determined by the string
    #
    # @api private
    def determine_type_from_string(string)
      if string =~ TYPE_FORMAT and const_defined?(string, *EXTRA_CONST_ARGS)
        const_get(string, *EXTRA_CONST_ARGS)
      end
    end

  end # module TypeLookup
end # module Virtus
