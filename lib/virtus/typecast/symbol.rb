module Virtus
  module Typecast

    # Typecast Symbol values
    class Symbol < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::Symbol.to_string(:name)  # => "name"
      #
      # @param [Symbol] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

    end # class Symbol
  end # module Typecast
end # module Virtus
