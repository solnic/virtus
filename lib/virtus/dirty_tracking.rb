module Virtus
  module DirtyTracking
    # @api private
    # TODO: document
    def self.included(base)
      base.extend(DirtyTracking::Attributes)
    end

    # @api public
    # TODO: document
    def attribute_dirty!(name, value)
      dirty_attributes[name] = value
    end

    # @api public
    def dirty_attributes
      @_dirty_attributes ||= {}
    end

    # @api public
    def original_attributes
      @_original_attributes ||= attributes.dup.freeze
    end

    module Attributes

      # @api public
      # TODO: document
      def attribute(name, type, options = {})
        _create_writer_with_dirty_tracking(name, super)
      end

      # @api private
      def new(attributes = {})
        model = super
        model.original_attributes
        model
      end

      private

      # @api private
      # TODO: document
      def _create_writer_with_dirty_tracking(name, attribute)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          chainable(:dirty_tracking) do
            #{attribute.writer_visibility}

            def #{name}=(value)
              prev_value = #{name}
              new_value  = super

              if prev_value != new_value
                attribute_dirty!(:#{name}, new_value)
              end

              new_value
            end
          end
        RUBY
      end
    end # Attributes
  end # DirtyTracking
end # Virtus
