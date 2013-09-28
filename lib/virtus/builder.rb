module Virtus

  # Class to build a Virtus module with it's own config
  #
  # This allows for individual Virtus modules to be included in
  # classes and not impacted by the global Virtus config,
  # which is implemented using Virtus::config.
  #
  # @private
  class Builder

    # Return module
    #
    # @return [Module]
    #
    # @api private
    attr_reader :mod

    # Return config
    #
    # @return [config]
    #
    # @api private
    attr_reader :config

    # Builds a new Virtus module
    #
    # The block is passed to Virtus::config
    #
    # @example
    #   ModuleBuilder.call do |config|
    #     # config settings
    #   end
    #
    # @return [Module]
    #
    # @api public
    def self.call(options = {}, &block)
      new(Configuration.build(options, &block)).mod
    end

    # @api private
    def self.pending
      @pending ||= []
    end

    # Initializes a new ModuleBuilder
    #
    # @param [Configuration] config
    # @param [Module] mod
    #
    # @return [undefined]
    #
    # @api private
    def initialize(conf, mod = Module.new)
      @config, @mod = conf, mod
      add_included_hook
      add_extended_hook
    end

    private

    # Adds the .included hook to the anonymous module which then defines the
    # .attribute method to override the default.
    #
    # @return [Module]
    #
    # @api private
    def add_included_hook
      with_attribute_method do |attribute_method|
        constructor     = config.constructor
        mass_assignment = config.mass_assignment
        finalize        = config.finalize
        extensions      = core_extensions
        inclusions      = core_inclusions

        mod.define_singleton_method :included do |object|
          super(object)
          Builder.pending << object unless finalize
          extensions.each { |mod| object.extend(mod) }
          inclusions.each { |mod| object.send(:include, mod) }
          object.send(:include, Model::Constructor)    if constructor
          object.send(:include, Model::MassAssignment) if mass_assignment
          object.send(:define_singleton_method, :attribute, attribute_method)
        end
      end
    end

    # @api private
    def add_extended_hook
      with_attribute_method do |attribute_method|
        mass_assignment = config.mass_assignment
        extensions      = core_inclusions + core_extensions

        mod.define_singleton_method :extended do |object|
          super(object)
          extensions.each { |mod| object.extend(mod) }
          object.extend(Model::MassAssignment) if mass_assignment
          object.send :define_singleton_method, :attribute, attribute_method
        end
      end
    end

    # @api private
    def options
      { :coerce             => config.coerce,
        :finalize           => config.finalize,
        :strict             => config.strict,
        :configured_coercer => config.coercer }
    end

    # @api private
    def core_inclusions
      [Model::Core]
    end

    # @api private
    def core_extensions
      []
    end


    # Wrapper for the attribute method that is used in .add_included_hook
    # The coercer is passed in the unused key :configured_coercer to allow the
    # property encapsulation by Virtus::Attribute::Coercer, where the
    # coercion method is known.
    #
    # @return [Proc(lambda)]
    #
    # @api private
    def attribute_method
      module_options = options

      lambda do |name, type = Object, options = {}|
        super(name, type, module_options.merge(options))
      end
    end

    # @api private
    def with_attribute_method
      yield(attribute_method)
    end

  end # class Builder

  # @private
  class ModelBuilder < Builder
  end # ModelBuilder

  # @private
  class ModuleBuilder < Builder

    private

    # @api private
    def add_included_hook
      with_attribute_method do |attribute_method|
        inclusions = core_inclusions

        inclusions << Model::Constructor    if config.constructor
        inclusions << Model::MassAssignment if config.mass_assignment

        mod.define_singleton_method :included do |object|
          super(object)
          object.extend(ModuleExtensions)
          object.instance_variable_set('@inclusions', inclusions)
          object.send(:define_singleton_method, :attribute, attribute_method)
        end
      end
    end

  end # ModuleBuilder

  # @private
  class ValueObjectBuilder < Builder

    # @api private
    def initialize(config, mod = Module.new)
      super
      @config.constructor = true
    end

    private

    # @api private
    def options
      super.update(:writer => :private)
    end

    # @api private
    def core_inclusions
      super << ValueObject::AllowedWriterMethods << ValueObject::InstanceMethods
    end

    # @api private
    def core_extensions
      super << ValueObject::AllowedWriterMethods
    end

  end # ValueObjectBuilder

end # module Virtus
