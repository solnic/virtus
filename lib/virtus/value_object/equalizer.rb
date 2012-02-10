module Virtus
  module ValueObject

    # A type of Module for dynamically defining and hosting equality methods
    class Equalizer < Module

      # Name of hosting Class or Module that will be used for #inspect
      #
      # @return [String]
      #
      # @api private
      attr_reader :host_name

      # List of methods that will be used to define equality methods
      #
      # @return [Array(Symbol)]
      #
      # @api private
      attr_reader :keys

      # Initialize an Equalizer with the given keys
      #
      # Will use the keys with which it is initialized to define #eql?, #==,
      #   and #hash
      #
      # @api private
      def initialize(host_name, keys = [])
        @host_name = host_name
        @keys      = keys
      end

      # Append a key and compile the equality methods
      #
      # @return [Equalizer] self
      #
      # @api private
      def <<(key)
        @keys << key
        compile
      end

      # Compile the equalizer methods based on #keys
      #
      # @return [self]
      #
      # @api private
      def compile
        define_inspect_method
        define_eql_method
        define_equivalent_method
        define_hash_method
        self
      end

    private

      # Define an inspect method that reports the values of the instance's keys
      #
      # @return [undefined]
      #
      # @api private
      def define_inspect_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def inspect
            "#<#{host_name} #{keys.map { |key| "#{key}=\#{#{key}.inspect}" }.join(' ')}>"
          end
        RUBY
      end

      # Define an #eql? method based on the instance's values identified by #keys
      #
      # @return [undefined]
      #
      # @api private
      def define_eql_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def eql?(other)
            return true if equal?(other)
            instance_of?(other.class) &&
            #{keys.map { |key| "#{key}.eql?(other.#{key})" }.join(' && ')}
          end
        RUBY
      end

      # Define an #== method based on the instance's values identified by #keys
      #
      # @return [undefined]
      #
      # @api private
      def define_equivalent_method
        respond_to, equivalent = compile_strings_for_equivalent_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def ==(other)
            return true if equal?(other)
            return false unless kind_of?(other.class) || other.kind_of?(self.class)
            #{respond_to.join(' && ')} && #{equivalent.join(' && ')}
          end
        RUBY
      end

      # Define a #hash method based on the instance's values identified by #keys
      #
      # @return [undefined]
      #
      # @api private
      def define_hash_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def hash
            self.class.hash ^ #{keys.map { |key| "#{key}.hash" }.join(' ^ ')}
          end
        RUBY
      end

      # Return a list of strings containing ruby code for method generation
      #
      # @return [Array(Array<String>, Array<String>)]
      #
      # @api private
      def compile_strings_for_equivalent_method
        respond_to = []
        equivalent = []

        keys.each do |key|
          respond_to << "other.respond_to?(#{key.inspect})"
          equivalent << "#{key} == other.#{key}"
        end

        [ respond_to, equivalent ]
      end

    end # class Equalizer
  end # module ValueObject
end # module Virtus
