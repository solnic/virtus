module Virtus
  module Typecast

    # TrueClass
    #
    class TrueClass < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::TrueClass.to_string(true)  # => "true"
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
  end # module Typecast
end # module Virtus
