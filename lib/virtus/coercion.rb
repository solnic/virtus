module Virtus

  # Coerce
  #
  class Coercion

    # Return a class that matches given name
    #
    # Defaults to Virtus::Coercion::Object
    #
    # @example
    #   Virtus::Coercion['String'] # => Virtus::Coercion::String
    #
    # @param [String]
    #
    # @return [Class]
    #
    # @api private
    def self.[](name)
      const_defined?(name, false) ? const_get(name, false) : Object
    end

    if RUBY_VERSION < '1.9'
      def self.[](name)
        const_defined?(name) ? const_get(name) : Object
      end
    end

  end # Coerce
end # Virtus
