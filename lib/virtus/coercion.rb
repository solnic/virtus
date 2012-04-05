module Virtus

  # Coerce abstract class
  #
  # @abstract
  #
  class Coercion
    extend DescendantsTracker
    extend TypeLookup
    extend Options

    accept_options :primitive

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
      determine_type(name) or Coercion::Object
    end

  end # Coerce
end # Virtus
