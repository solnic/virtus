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

    # Initialized a configuration instance
    #
    # @return [undefined]
    #
    # @api private
    def initialize(options={})
      @finalize        = options.fetch(:finalize,true)
      @coerce          = options.fetch(:coerce,true)
      @strict          = options.fetch(:strict,false)
      @constructor     = options.fetch(:constructor,true)
      @mass_assignment = options.fetch(:mass_assignment,true)
      @coercer         = Coercible::Coercer.new

      yield self if block_given?
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
