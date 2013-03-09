module Virtus
  class Attribute
    class Accessor

      # Lazy accessor provides evaluating default values on first read
      #
      # @api private
      class LazyAccessor < self

        # Read attribute value and set default value if attribute is not set yet
        #
        # @see Accessor#get
        #
        # @return [Object]
        #
        # @api private
        def get(instance)
          if instance.instance_variable_defined?(reader.instance_variable_name)
            super
          else
            value = writer.default_value.call(instance, self)
            writer.call(instance, value)
            value
          end
        end

        # Return if the accessor is lazy
        #
        # @return [TrueClass]
        #
        # @api private
        def lazy?
          true
        end
      end # LazyAccessor

    end # class Accessor
  end # class Attribute
end # module Virtus
