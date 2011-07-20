module Virtus

  # Typecast
  #
  module Typecast

    # Return a class that matches given name.
    # Defaults to Virtus::Typecast::Object
    #
    # @example
    #   Virtus::Typecast['String'] # => Virtus::Typecast::String
    #
    # @param [String]
    #
    # @return [Class]
    #
    # @api private
    def self.[](name)
      const_defined?(name) ? const_get(name) : Object
    end

  end # Typecast
end # Virtus
