module Virtus

  # Include this Module for Value Object semantics
  #
  # The idea is that instances should be immutable and compared based on state
  #   (rather than identity, as is typically the case)
  #
  # @example
  #   class GeoLocation
  #     include Virtus::ValueObject
  #     attribute :latitude,  Float
  #     attribute :longitude, Float
  #   end
  #
  #   location = GeoLocation.new(:latitude => 10, :longitude => 100)
  #   same_location = GeoLocation.new(:latitude => 10, :longitude => 100)
  #   location == same_location       #=> true
  #   hash = { location => :foo }
  #   hash[same_location]             #=> :foo
  module ValueObject

    # Callback to configure including Class as a Value Object
    #
    # Including Class will include Virtus and have additional
    #   value object semantics defined in this module
    #
    # @return [Undefined]
    #
    # TODO: stacking modules is getting painful
    #   time for Facets' module_inheritance, ActiveSupport::Concern or the like
    #
    # @api private
    def self.included(base)
      base.instance_eval do
        include ::Virtus
        include InstanceMethods
        extend ClassMethods
        private :attributes=
      end
    end

    private_class_method :included

    module InstanceMethods

      # the #get_attributes method accept a Proc object that will filter
      # out an attribute when the block returns false. the ValueObject
      # needs all the attributes, so we allow every attribute.
      FILTER_NONE = proc { true }

      # @api private
      def with(attribute_updates)
        self.class.new(
          attribute_set.get(self, &FILTER_NONE).merge(attribute_updates)
        )
      end

      # ValueObjects are immutable and can't be cloned
      #
      # They always represent the same value
      #
      # @example
      #
      #   value_object.clone === value_object # => true
      #
      # @return [self]
      #
      # @api public
      def clone
        self
      end
      alias dup clone

    end

    module ClassMethods

      # Define an attribute on the receiver
      #
      # The Attribute will have private writer methods (eg., immutable instances)
      #   and be used in equality/equivalence comparisons
      #
      # @example
      #   class GeoLocation
      #     include Virtus::ValueObject
      #
      #     attribute :latitude,  Float
      #     attribute :longitude, Float
      #   end
      #
      # @see Virtus::ClassMethods.attribute
      #
      # @return [self]
      #
      # @api public
      def attribute(name, type, options = {})
        equalizer << name
        super name, type, options.merge(:writer => :private)
      end

      # Define and include a module that provides Value Object semantics
      #
      # Included module will have #inspect, #eql?, #== and #hash
      # methods whose definition is based on the _keys_ argument
      #
      # @example
      #   virtus_class.equalizer
      #
      # @return [Equalizer]
      #   An Equalizer module which defines #inspect, #eql?, #== and #hash
      #   for instances of this class
      #
      # @api public
      def equalizer
        @equalizer ||=
          begin
            equalizer = Equalizer.new(name || inspect)
            include equalizer
            equalizer
          end
      end

      # The list of writer methods that can be mass-assigned to in #attributes=
      #
      # @return [Set]
      #
      # @api private
      def allowed_writer_methods
        @allowed_writer_methods ||=
          begin
            allowed_writer_methods = super
            allowed_writer_methods += attribute_set.map{|attr| "#{attr.name}="}
            allowed_writer_methods.to_set.freeze
          end
      end

    end # module ClassMethods
  end # module ValueObject
end # module Virtus
