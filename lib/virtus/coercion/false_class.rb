module Virtus
  class Coercion

    # Coerce false values
    class FalseClass < Object
      primitive ::FalseClass

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::FalseClass.to_string(false)  # => "false"
      #
      # @param [FalseClass] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

    end # class FalseClass
  end # class Coercion
end # module Virtus
