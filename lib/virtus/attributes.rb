module Virtus
  module Attributes
    class << self
      # @api semipublic
      # TODO: document
      def determine_type(class_or_name)
        if class_or_name.is_a?(Class) && class_or_name < Attributes::Object
          class_or_name
        elsif const_defined?(name = class_or_name.to_s)
          const_get(name)
        end
      end
    end

    # @api private
    # TODO: document
    def new(attributes = {})
      model = super
      model.attributes = attributes
      model
    end

    # @api public
    # TODO: document
    def attribute(name, type, options = {})
      attribute_klass  = Attributes.determine_type(type)
      attributes[name] = attribute = attribute_klass.new(name, self, options)

      _create_reader(name, attribute)
      _create_writer(name, attribute)

      attribute
    end

    # @api public
    # TODO: document
    def attributes
      @attributes ||= {}
    end

    private

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
    end

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

    # @api private
    # TODO: document
    def const_missing(name)
      Attributes.determine_type(name) || super
    end
  end # Attributes
end # Virtus
