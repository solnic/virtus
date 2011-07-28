module Virtus
  class Coercion

    # Coerce Symbol values
    class Symbol < Object
      primitive ::Symbol

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::Symbol.to_string(:name)  # => "name"
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
  end # class Coercion
end # module Virtus
