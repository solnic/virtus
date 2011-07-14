module Virtus
  module Typecast

    # Symbol
    #
    class Symbol < Base

      # @api public
      def self.to_string(value)
        value.to_s
      end

    end # class Integer
  end # module Typecast
end # module Virtus
