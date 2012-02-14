# -*- encoding: utf-8 -*-

require 'virtus'
require 'virtus/value_object/equalizer'

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
      end
    end

    private_class_method :included

    module InstanceMethods
      # the #get_attributes method accept a Proc object that will filter
      # out an attribute when the block returns false. the ValueObject
      # needs all the attributes, so we allow every attribute.
      FILTER_NONE = proc { true }

      def initialize(attributes = {})
        # TODO: Think of a better way of doing this
        allowed_writer_methods = self.class.allowed_writer_methods
        allowed_writer_methods += self.class.attributes.map{|attr| "#{attr.name}="}
        allowed_writer_methods.to_set.freeze
        set_attributes(attributes, allowed_writer_methods)
      end

      def with(attribute_updates)
        self.class.new(get_attributes(&FILTER_NONE).merge(attribute_updates))
      end
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
        options[:writer] = :private
        super
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

    end # module ClassMethods
  end # module ValueObject
end # module Virtus
