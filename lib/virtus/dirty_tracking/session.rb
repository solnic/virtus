module Virtus
  module DirtyTracking
    class Session
      attr_reader :subject

      # @api semipublic
      def initialize(subject)
        @subject = subject
      end

      # Returns original attributes of the subject
      #
      # @return [Hash]
      #   a hash of attributes indexed by attribute names
      #
      # @api semipublic
      def original_attributes
        @_original_attributes ||= subject.attributes.dup
      end

      # Returns dirty attributes of the subject
      #
      # @return [Hash]
      #   a hash of attributes indexed by attribute names
      #
      # @api semipublic
      def dirty_attributes
        (@_dirty_attributes ||= {}).update(complex_attributes)
      end

      # Sets an attribute as dirty
      #
      # @param [Symbol] name
      #   the name of an attribute
      #
      # @param [Object] value
      #   the value of an attribute
      #
      # @api semipublic
      def dirty!(name, value)
        dirty_attributes[name] = value
      end

      # Returns if an object is dirty or if an attribute with the given name is
      # dirty.
      #
      # @param [Symbol] name
      #   the name of an attribute
      #
      # @return [TrueClass, FalseClass]
      #
      # @api semipublic
      def dirty?(name = nil)
        name ? dirty_attributes.key?(name) : dirty_attributes.any?
      end

      private

      # Returns a values of complex dirty attributes that can be modified via
      # their own APIs like Hash[] or Array<<
      #
      # @return [Hash]
      #   an attributes hash indexed by attribute names
      #
      # @api private
      def complex_attributes
        values = {}

        complex_attributes_set.each do |name, attribute|
          value = subject.__send__(name)

          if original_attributes[name] != value
            values[name] = value
          end
        end

        values
      end

      # Returns a hash of complex attribute instances defined on
      # the subject's class.
      #
      # @return [Hash]
      #   the attribute instances hash indexed by attribute names
      #
      # @api private
      def complex_attributes_set
        @_complex_attributes_set ||= subject.class.attributes.select do |name, attribute|
          attribute.complex?
        end
      end
    end # Session
  end # DirtyTracking
end # Virtus
