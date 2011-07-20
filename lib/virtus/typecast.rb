module Virtus

  # Typecast
  #
  module Typecast

    CLASS_MAP = {
      'Array'      => Array,
      'BigDecimal' => BigDecimal,
      'Date'       => Date,
      'DateTime'   => DateTime,
      'FalseClass' => FalseClass,
      'Fixnum'     => Fixnum,
      'Float'      => Float,
      'Hash'       => Hash,
      'String'     => String,
      'Symbol'     => Symbol,
      'Time'       => Time,
      'TrueClass'  => TrueClass
    }.freeze

    # Return a class that matches given name.
    # Defaults to Virtus::Typecast::Object
    #
    # @example
    #   Virtus::Typecast['String'] # => Virtus::Typecat::String
    #
    # @param [String]
    #
    # @return [Class]
    #
    # @api private
    def self.[](name)
      CLASS_MAP.fetch(name, Object)
    end

  end # Typecast
end # Virtus
