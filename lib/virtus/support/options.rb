module Virtus

  # A module that adds class and instance level options
  module Options

    # Returns default options hash for a given attribute class
    #
    # @example
    #   Virtus::Attribute::String.options
    #   # => {:primitive => String}
    #
    # @return [Hash]
    #   a hash of default option values
    #
    # @api public
    def options
      accepted_options.each_with_object({}) do |option_name, options|
        option_value         = send(option_name)
        options[option_name] = option_value unless option_value.nil?
      end
    end

    # Returns an array of valid options
    #
    # @example
    #   Virtus::Attribute::String.accepted_options
    #   # => [:primitive, :accessor, :reader, :writer]
    #
    # @return [Array]
    #   the array of valid option names
    #
    # @api public
    def accepted_options
      @accepted_options ||= []
    end

    # Defines which options are valid for a given attribute class
    #
    # @example
    #   class MyAttribute < Virtus::Attribute::Object
    #     accept_options :foo, :bar
    #   end
    #
    # @return [self]
    #
    # @api public
    def accept_options(*new_options)
      add_accepted_options(new_options)
      new_options.each { |option| define_option_method(option) }
      descendants.each { |descendant| descendant.add_accepted_options(new_options) }
      self
    end

  protected

    # Adds a reader/writer method for the give option name
    #
    # @return [undefined]
    #
    # @api private
    def define_option_method(option)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{option}(value = Undefined)           # def self.primitive(value = Undefined)
          return @#{option} if value.equal?(Undefined)  #   return @primitive if value.equal?(Undefined)
          @#{option} = value                            #   @primitive = value
          self                                          #   self
        end                                             # end
      RUBY
    end

    # Sets default options
    #
    # @param [#each] new_options
    #   options to be set
    #
    # @return [self]
    #
    # @api private
    def set_options(new_options)
      new_options.each { |pair| send(*pair) }
      self
    end

    # Adds new options that an attribute class can accept
    #
    # @param [#to_ary] new_options
    #   new options to be added
    #
    # @return [self]
    #
    # @api private
    def add_accepted_options(new_options)
      accepted_options.concat(new_options)
      self
    end

  private

    # Adds descendant to descendants array and inherits default options
    #
    # @param [Class] descendant
    #
    # @return [undefined]
    #
    # @api private
    def inherited(descendant)
      super
      descendant.add_accepted_options(accepted_options).set_options(options)
    end

  end # module Options
end # module Virtus
