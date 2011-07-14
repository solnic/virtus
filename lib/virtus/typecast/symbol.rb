module Virtus
  module Typecast

    # Symbol
    #
    class Symbol < Object

      # @api public
      def self.to_string(value)
        value.to_s
      end

    end # class Symbol
  end # module Typecast
end # module Virtus
