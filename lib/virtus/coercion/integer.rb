module Virtus
  class Coercion

    # Coerce Fixnum values
    class Integer < Numeric
      primitive ::Integer

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::Fixnum.to_string(1)  # => "1"
      #
      # @param [Fixnum] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # Passthrough the value
      #
      # @example
      #   Virtus::Coercion::Fixnum.to_integer(1)  # => 1
      #
      # @param [Fixnum] value
      #
      # @return [Float]
      #
      # @api public
      def self.to_integer(value)
        value
      end

      # Coerce given value to a Boolean
      #
      # @example with a 1
      #   Virtus::Coercion::Fixnum.to_boolean(1)  # => true
      #
      # @example with a 0
      #   Virtus::Coercion::Fixnum.to_boolean(0)  # => false
      #
      # @param [Fixnum] value
      #
      # @return [BigDecimal]
      #
      # @api public
      def self.to_boolean(value)
        case value
        when 1 then true
        when 0 then false
        else
          value
        end
      end

      # Coerce given value to a DateTime
      #
      # @example
      #   Virtus::Coercion::Fixnum.to_datetime(0)  # => Thu, 01 Jan 1970 00:00:00 +0000
      #
      # @param [Integer] value
      #
      # @return [DateTime]
      #
      # @api public
      def self.to_datetime(value)
        # FIXME: Remove after Rubinius 2.0 is released
        if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
          datetime_format = '%Q'
          value = "#{value * 10**3}"
        else
          datetime_format = '%s'
          value = "#{value}"
        end

        ::DateTime.strptime(value, datetime_format)
      end

    end # class Fixnum
  end # class Coercion
end # module Virtus
