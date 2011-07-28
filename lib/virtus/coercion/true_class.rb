module Virtus
  class Coercion

    # Coerce true values
    class TrueClass < Object
      primitive ::TrueClass

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::TrueClass.to_string(true)  # => "true"
      #
      # @param [TrueClass] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

    end # class TrueClass
  end # class Coercion
end # module Virtus
