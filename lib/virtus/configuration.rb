module Virtus

  # A Configuration instance
  class Configuration

    # Access the finalize setting for this instance
    attr_accessor :finalize

    # Access the coerce setting for this instance
    attr_accessor :coerce

    # Access the strict setting for this instance
    attr_accessor :strict

    # Access the nullify_blank setting for this instance
    attr_accessor :nullify_blank

    # Access the use_default_on_nil setting for this instance
    attr_accessor :use_default_on_nil

    # Access the required setting for this instance
    attr_accessor :required

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
      @finalize           = options.fetch(:finalize, true)
      @coerce             = options.fetch(:coerce, true)
      @strict             = options.fetch(:strict, false)
      @nullify_blank      = options.fetch(:nullify_blank, false)
      @use_default_on_nil = options.fetch(:use_default_on_nil, false)
      @required           = options.fetch(:required, true)
      @constructor        = options.fetch(:constructor, true)
      @mass_assignment    = options.fetch(:mass_assignment, true)
      @coercer            = Coercible::Coercer.new

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
        :nullify_blank      => nullify_blank,
        :use_default_on_nil => use_default_on_nil,
        :required           => required,
        :configured_coercer => coercer }.freeze
    end

  end # class Configuration
end # module Virtus
