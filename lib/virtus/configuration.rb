module Virtus

  # A Configuration instance
  class Configuration

    # Access the coerce setting for this instance
    attr_accessor :coerce

    # Build new configuration instance using the passed block
    #
    # @example
    #   Configuration.build do |config|
    #     config.coerce = false
    #   end
    #
    # @return [Configuration]
    #
    # @api public
    def self.build(&block)
      new.call(&block)
    end

    # Initialized a configuration instance
    #
    # @return [undefined]
    #
    # @api private
    def initialize
      @coerce  = true
      @coercer = Coercible::Coercer.new
    end

    # Provide access to the attributes and methods via the passed block
    #
    # @example
    #   configuration.call do |config|
    #     config.coerce = false
    #   end
    #
    # @return [self]
    #
    # @api private
    def call(&block)
      block.call(self) if block_given?
      self
    end

    # Access the coercer for this instance and optional configure a
    # new coercer with the passed block
    #
    # @example
    #   configuration.coercer do |config|
    #     config.string.boolean_map = { true => '1', false => '0' }
    #   end
    #
    # @return [Coercer]
    #
    # @api private
    def coercer(&block)
      @coercer = Coercible::Coercer.new(&block) if block_given?
      @coercer
    end

  end # class Configuration
end # module Virtus
