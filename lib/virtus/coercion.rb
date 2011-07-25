module Virtus

  # Coerce
  #
  class Coercion
    extend DescendantsTracker
    extend TypeLookup

    # Return a class that matches given name
    #
    # Defaults to Virtus::Coercion::Object
    #
    # @example
    #   Virtus::Coercion['String'] # => Virtus::Coercion::String
    #   Virtus::Coercion[String]   # => Virtus::Coercion::String
    #
    # @param [String]
    #
    # @return [Class]
    #
    # @api private
    def self.[](name)
      determine_type(name) || Coercion::Object
    end

  end # Coerce
end # Virtus
