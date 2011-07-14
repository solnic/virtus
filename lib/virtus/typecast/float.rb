module Virtus
  module Typecast

    # Float
    #
    class Float < Base

      # @api public
      def self.to_i(value)
        value.to_i
      end

      # @api public
      def self.to_d(value)
        value.to_s.to_d
      end

    end # class Float
  end # module Typecast
end # module Virtus
