module Virtus
  module DirtyTracking
    # @api private
    # TODO: document
    def self.included(base)
      base.extend(DirtyTracking::Attributes)
    end

    # @api public
    # TODO: document
    def dirty?
      dirty_session.dirty?
    end

    # @api public
    # TODO: document
    def attribute_dirty?(name)
      dirty_session.dirty?(name)
    end

    # @api public
    # TODO: document
    def attribute_dirty!(name, value)
      dirty_session.dirty!(name, value)
    end

    # @api public
    # TODO: document
    def dirty_attributes
      dirty_session.dirty_attributes
    end

    # @api public
    # TODO: document
    def original_attributes
      dirty_session.original_attributes
    end

    # @api private
    # TODO: document
    def dirty_session
      @_dirty_session ||= Session.new(self)
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
                unless original_attributes.key?(:#{name})
                  original_attributes[:#{name}] = prev_value
                end

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
