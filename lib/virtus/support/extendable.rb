module Virtus
  module Extendable
    def register_extension(extension)
      @extensions ||= Set.new
      @extensions << extension
      self
    end

    def extensions
      extensions = @extensions || Set.new
      extensions |= superclass.extensions if superclass.respond_to?(:extensions)
      extensions
    end

    def extensions_for(object)
      extensions.select { |ext| ext.extend?(object) }
    end
  end
end
