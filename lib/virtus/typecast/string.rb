module Virtus
  module Typecast

    # Typecast any object to a string
    class String

      # Typecast value to a string
      #
      # @example
      #   Virtus::Typecast::String.call(1)  # => '1'
      #   Virtus::Typecast::String.call([]) # => '[]'
      #
      # @param [Object] value
      #
      # @return [String]
      #
      # @api public
      def self.call(value)
        value.to_s
      end

    end # class String
  end # module Typecast
end # module Virtus
