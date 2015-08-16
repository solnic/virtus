module Virtus
  module Lite

    class Boolean; end

    module ClassMethods

      attr_reader :attributes
      attr_reader :set_attributes

      def attribute( name, type = nil, options = {} )
        @attributes ||= []
        @attributes << name unless @attributes.include? name
        define_method( "#{ name }=") do |value|
          @set_attributes ||= []
          @set_attributes << name
          instance_variable_set "@#{ name }", value
        end
        define_method( name ) do
          value = instance_variable_get "@#{ name }"
          coercer = options[ :coercer ]
          default = options[ :default ]
          if coercer
            coercer.call value
          elsif value.nil? and not default.nil? and default.is_a? Symbol and respond_to? default
            send default
          else
            if type.is_a? Array
              if value.nil?
                []
              elsif value.is_a? Array
                value.map { |v| determine_value name, v, type.first, options }
              else
                determine_value name, value, type.first, options
              end
            else
              determine_value name, value, type, options
            end
          end
        end
        # private :"#{ name }"  if options[ :reader ] == :private
        # private :"#{ name }=" if options[ :writer ] == :private
        self
      end
    end

    def self.included( base )
      base.extend ClassMethods
    end

    def attributes
      Hash[ self.class.attributes.map { |v| [ v, send( v ) ] } ] || {}
    end

    def []( key )
      send( key ) if self.class.attributes.include? key
    end

    private

    def determine_value( name, value, type, options )
      default = options[ :default ]
      if value.nil? and not default.nil?
        value = default
      elsif type and not value.is_a? type
        if not value.nil? and @set_attributes.include? name
          if value.is_a? Hash and not type.is_a? Hash
            value = type.new value
          else
            value = convert value, type
          end
        end
      end
      value
    end

    def initialize( params = {} )
      unless params.nil?
        params.each do |name, value|
          self.send( :"#{name}=", value ) if respond_to? "#{ name }="
        end
      end
      self.class.send( :define_method, :to_hash ) do
        Hash[ self.class.attributes.map { |attribute| [ attribute, send( attribute ) ] } ]
      end
    end

    def convert( value, type )
      case type.to_s
      when 'String'
        value.to_s
      when 'Integer', 'Fixnum', 'Bignum'
        if value.respond_to? :to_i
          value.to_i
        elsif value.is_a? TrueClass or value.is_a? FalseClass
          value ? 1 : 0
        else
          0
        end
      when 'Float'
        if value.respond_to? :to_f
          value.to_f
        elsif value.is_a? TrueClass or value.is_a? FalseClass
          value ? 1.0 : 0.0
        end
      when 'Virtus::Attribute::Boolean', 'Virtus::Lite::Boolean'
        if value.nil?
          false
        elsif value.is_a? String
          value != ''
        elsif value.is_a? Integer
          value != 0
        elsif value.is_a? TrueClass or value.is_a? FalseClass
          value
        elsif value.is_a? Float
          value != 0.0
        else
          true
        end
      end
    end
  end
end