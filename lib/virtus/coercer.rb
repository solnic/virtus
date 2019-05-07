module Virtus
  # Abstract coercer class
  #
  class Coercer
    include Equalizer.new(inspect) << :primitive << :type

    # @api private
    attr_reader :primitive, :type

    # @api private
    def initialize(type)
      @type      = type
      @primitive = type.primitive
    end

    # Coerce input value into expected primitive type
    #
    # @param [Object] input
    #
    # @return [Object] coerced input
    #
    # @api public
    def call(_input)
      NotImplementedError.new("#{self.class}#call must be implemented")
    end

    # Return if the input value was successfuly coerced
    #
    # @param [Object] input
    #
    # @return [Object] coerced input
    #
    # @api public
    def success?(primitive, input)
      input.is_a?(primitive)
    end
  end # Coercer
end # Virtus
