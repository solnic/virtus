module Virtus
  module Typecast

    # Fixnum
    #
    class Fixnum < Object

      # @api public
      def self.to_f(value)
        value.to_f
      end

      # @api public
      def self.to_d(value)
        value.to_s.to_d
      end

      # @api public
      def self.to_boolean(value)
        value == 1
      end

    end # class Fixnum
  end # module Typecast
end # module Virtus
