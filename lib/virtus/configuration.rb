module Virtus

  # A Configuration instance
  class Configuration

    # Access the finalize setting for this instance
    attr_accessor :finalize

    # Access the coerce setting for this instance
    attr_accessor :coerce

    # Access the strict setting for this instance
    attr_accessor :strict

    # Access the constructor setting for this instance
    attr_accessor :constructor

    # Access the mass-assignment setting for this instance
    attr_accessor :mass_assignment

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
    def self.build(options = {}, &block)
      config = new.call(&block)
      options.each { |key, value| config.public_send("#{key}=", value) }
      config
    end

    # Initialized a configuration instance
    #
    # @return [undefined]
    #
    # @api private
    def initialize
      @finalize        = true
      @coerce          = true
      @strict          = false
      @constructor     = true
      @mass_assignment = true
      @coercer         = Coercible::Coercer.new
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

    # @api private
    def to_h
      { :coerce             => coerce,
        :finalize           => finalize,
        :strict             => strict,
        :configured_coercer => coercer }.freeze
    end

  end # class Configuration
end # module Virtus
