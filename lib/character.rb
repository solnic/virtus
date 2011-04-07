require 'pathname'
require 'set'
require 'date'
require 'time'
require 'bigdecimal'
require 'bigdecimal/util'

module Character
  module Undefined; end

  def self.included(base)
    base.extend(Attributes)
  end

  def attributes
    attributes = {}

    self.class.attributes.each do |name, attribute|
      attributes[name] = __send__(attribute.name)
    end

    attributes
  end
end

dir = Pathname(__FILE__).dirname.expand_path

require dir + 'character/attributes'
require dir + 'character/attributes/typecast/numeric'
require dir + 'character/attributes/typecast/time'
require dir + 'character/attributes/attribute'
require dir + 'character/attributes/object'
require dir + 'character/attributes/boolean'
require dir + 'character/attributes/date'
require dir + 'character/attributes/date_time'
require dir + 'character/attributes/numeric'
require dir + 'character/attributes/decimal'
require dir + 'character/attributes/float'
require dir + 'character/attributes/integer'
require dir + 'character/attributes/string'
require dir + 'character/attributes/time'
