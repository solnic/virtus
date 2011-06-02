module Virtus
  module Attributes
    class << self
      # Returns a Virtus::Attributes::Object sub-class based on a name or class.
      #
      # @param [Class,String] class_or_name
      #   name of a class or a class itself
      #
      # @return [Class]
      #   one of the Virtus::Attributes::Object sub-class
      #
      # @api semipublic
      def determine_type(class_or_name)
        if class_or_name.is_a?(Class) && class_or_name < Attributes::Object
          class_or_name
        elsif const_defined?(name = class_or_name.to_s)
          const_get(name)
        end
      end
    end

    # Chains Class.new to be able to set attributes during initialization of
    # an object.
    #
    # @param [Hash] attributes
    #   the attributes hash to be set
    #
    # @return [Object]
    #
    # @api private
    def new(attributes = {})
      model = super
      model.attributes = attributes
      model
    end

    # Defines an attribute on an object's class.
    #
    # Usage:
    #
    #    class Book
    #      include Virtus
    #
    #      attribute :title,        String
    #      attribute :author,       String
    #      attribute :published_at, DateTime
    #      attribute :page_count,   Integer
    #    end
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Class] type
    #   the type class of an attribute
    #
    # @param [Hash] options
    #   the extra options hash
    #
    # @return [Virtus::Attributes::Object]
    #
    # @api public
    def attribute(name, type, options = {})
      attribute_klass  = Attributes.determine_type(type)
      attributes[name] = attribute = attribute_klass.new(name, self, options)

      _create_reader(name, attribute)
      _create_writer(name, attribute)

      attribute
    end

    # Returns all the attributes defined on a Class.
    #
    # @return [Hash]
    #   an attributes hash indexed by attribute names
    #
    # @api public
    def attributes
      @attributes ||= {}
    end

    private

    # Creates an attribute reader method
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Virtus::Attributes::Object] attribute
    #   an attribute instance
    #
    # @api private
    def _create_reader(name, attribute)
      instance_variable_name = attribute.instance_variable_name

      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        chainable(:attributes) do
          #{attribute.reader_visibility}

          def #{name}
            return #{instance_variable_name} if defined?(#{instance_variable_name})
            attribute = self.class.attributes[#{name.inspect}]
            #{instance_variable_name} = attribute ? attribute.get(self) : nil
          end
        end
      RUBY

      boolean_reader_name = "#{name}?"

      if attribute.kind_of?(Virtus::Attributes::Boolean)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          chainable(:attributes) do
            #{attribute.reader_visibility}

            def #{boolean_reader_name}
              #{name}
            end
          end
        RUBY
      end
    end

    # Creates an attribute writer method
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Virtus::Attributes::Object] attribute
    #   an attribute instance
    #
    # @api private
    def _create_writer(name, attribute)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        chainable(:attributes) do
          #{attribute.writer_visibility}

          def #{name}=(value)
            self.class.attributes[#{name.inspect}].set(self, value)
          end
        end
      RUBY
    end

    # Hooks into const missing process to determine types of attributes.
    #
    # It is used when an attribute is defined and a global class like String
    # or Integer is provided as the type which needs to be mapped to
    # Virtus::Attributes::String and Virtus::Attributes::Integer.
    #
    # @param [String] name
    #
    # @return [Class]
    #
    # @api private
    def const_missing(name)
      Attributes.determine_type(name) || super
    end
  end # Attributes
end # Virtus
