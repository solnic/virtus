module Virtus
  # == Dirty Tracking
  #
  # Dirty Tracking is an optional module that you include only if you need it.
  module DirtyTracking
    # Extends a class with DirtyTracking::Attributes module
    #
    # @param [Class] base
    #
    # @api private
    def self.included(base)
      base.extend(DirtyTracking::Attributes)
    end

    # Returns if an object is dirty
    #
    # @return [TrueClass, FalseClass]
    #
    # @api public
    def dirty?
      dirty_session.dirty?
    end

    # Returns if an attribute with the given name is dirty.
    #
    # @param [Symbol] name
    #
    # @return [TrueClass, FalseClass]
    #
    # @api public
    def attribute_dirty?(name)
      dirty_session.dirty?(name)
    end

    # Explicitly sets an attribute as dirty.
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Object] value
    #   a value of an attribute
    #
    # @api public
    def attribute_dirty!(name, value)
      dirty_session.dirty!(name, value)
    end

    # Returns all dirty attributes
    #
    # @return [Hash]
    #   a hash indexed with attribute names
    #
    # @api public
    def dirty_attributes
      dirty_session.dirty_attributes
    end

    # Returns original attributes
    #
    # @return [Hash]
    #   a hash indexed with attribute names
    #
    # @api public
    def original_attributes
      dirty_session.original_attributes
    end

    # Returns the current dirty tracking session
    #
    # @return [Virtus::DirtyTracking::Session]
    #
    # @api private
    def dirty_session
      @_dirty_session ||= Session.new(self)
    end

    module Attributes
      # Creates an attribute writer with dirty tracking
      #
      # @see Virtus::Attributes.attribute
      #
      # @return [Virtus::Attributes::Object]
      #
      # @api public
      def attribute(name, type, options = {})
        _create_writer_with_dirty_tracking(name, attribute = super)
        attribute
      end

      private

      # Creates an attribute writer method with dirty tracking
      #
      # @param [Symbol] name
      #   the name of an attribute
      #
      # @param [Virtus::Attributes::Object] attribute
      #   an attribute instance
      #
      # @api private
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
