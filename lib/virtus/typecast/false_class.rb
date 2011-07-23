module Virtus
  module Typecast

    # FalseClass
    #
    class FalseClass < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::FalseClass.to_string(false)  # => "false"
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
  end # module Typecast
end # module Virtus
