module Virtus

  # Class to build a Virtus module with it's own config
  #
  # This allows for individual Virtus modules to be included in
  # classes and not impacted by the global Virtus config,
  # which is implemented using Virtus::config.
  #
  # @private
  class Builder

    # @private
    class HookContext
      attr_reader :attribute_method, :config

      # @api private
      def initialize(attribute_method, config)
        @attribute_method, @config = attribute_method, config
      end

      # @api private
      def constructor?
        config.constructor
      end

      # @api private
      def mass_assignment?
        config.mass_assignment
      end

      # @api private
      def finalize?
        config.finalize
      end

    end # HookContext

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

    # Initializes a new Builder
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

    # @api private
    def all_extensions
      core_inclusions + core_extensions
    end

    # @api private
    def core_inclusions
      [Model::Core]
    end

    # @api private
    def core_extensions
      []
    end

    private

    # Adds the .included hook to the anonymous module which then defines the
    # .attribute method to override the default.
    #
    # @return [Module]
    #
    # @api private
    def add_included_hook
      with_hook_context do |context, builder|
        mod.define_singleton_method :included do |object|
          super(object)
          Builder.pending << object unless context.finalize?
          builder.core_extensions.each { |mod| object.extend(mod) }
          builder.core_inclusions.each { |mod| object.send(:include, mod) }
          object.send(:include, Model::Constructor)    if context.constructor?
          object.send(:include, Model::MassAssignment) if context.mass_assignment?
          object.define_singleton_method(:attribute, context.attribute_method)
        end
      end
    end

    # @api private
    def add_extended_hook
      with_hook_context do |context, builder|
        mod.define_singleton_method :extended do |object|
          super(object)
          builder.all_extensions.each { |mod| object.extend(mod) }
          object.extend(Model::MassAssignment) if context.mass_assignment?
          object.define_singleton_method(:attribute, context.attribute_method)
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

    # Wrapper for the attribute method that is used in .add_included_hook
    # The coercer is passed in the unused key :configured_coercer to allow the
    # property encapsulation by Virtus::Attribute::Coercer, where the
    # coercion method is known.
    #
    # @return [Proc(lambda)]
    #
    # @api private
    def attribute_method
      method_options = options

      lambda do |name, type = Object, options = {}|
        super(name, type, method_options.merge(options))
      end
    end

    # @api private
    def with_hook_context
      yield(HookContext.new(attribute_method, config), self)
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
      with_hook_context do |context, builder|
        inclusions = core_inclusions

        inclusions << Model::Constructor    if context.constructor?
        inclusions << Model::MassAssignment if context.mass_assignment?

        mod.define_singleton_method :included do |object|
          super(object)
          object.extend(ModuleExtensions)
          object.instance_variable_set('@inclusions', inclusions)
          object.send(:define_singleton_method, :attribute, context.attribute_method)
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

    # @api private
    def core_inclusions
      super << ValueObject::AllowedWriterMethods << ValueObject::InstanceMethods
    end

    # @api private
    def core_extensions
      super << ValueObject::AllowedWriterMethods
    end

    private

    # @api private
    def options
      super.update(:writer => :private)
    end

  end # ValueObjectBuilder

end # module Virtus
