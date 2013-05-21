module Virtus

  class Configuration

    attr_accessor :coerce

    def initialize
      @coerce = true # default
    end

    def call(&block)
      yield self if block_given?
      self
    end

    def coercer(&block)
      @coercer ||= Coercible::Coercer.new(&block)
    end

  end # class Configuration

end # module Virtus
