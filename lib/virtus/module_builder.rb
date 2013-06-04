module Virtus

  class ModuleBuilder

    def self.call(&block)
      config  = Configuration.new.call(&block)
      builder = self.new(config)
      builder.add_included_hook
      builder.mod
    end

    def initialize(configuration)
      @configuration = configuration

      @mod = Module.new do
        include Virtus
      end
    end

    # Accessor for the anonymous module
    def mod
      @mod
    end

    # Adds the .included hook to the anonymous module which then defines the
    # .attribute method to override the default.
    def add_included_hook
      configuration    = @configuration
      attribute_method = self.attribute_method(configuration)

      mod.module_eval do
        define_singleton_method :included do |object|
          super(object)
          object.send :define_singleton_method, :attribute, attribute_method
        end
      end
    end

    # Wrapper for the attribute method (proc) that is used in .add_included_hook
    # The coercer is passed in the unused key :configured_coercer to allow the
    # property encapsulation by Virtus::Attribute::Coercer, where the
    # coercion method is known.
    def attribute_method(configuration)
      Proc.new do |name, type, options = {}|
        module_options = {
          :coerce => configuration.coerce,
          :configured_coercer => configuration.coercer
        }

        super(name, type, module_options.merge(options))
      end
    end
  end

end # module Virtus
