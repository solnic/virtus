require 'pathname'
require 'bigdecimal'

module Character
  module Undefined; end

  def self.included(base)
    base.extend(Attribute)
  end
end

dir = Pathname(__FILE__).dirname.expand_path

require dir + 'character/attribute'
require dir + 'character/attribute/object'
require dir + 'character/attribute/boolean'
require dir + 'character/attribute/date'
require dir + 'character/attribute/date_time'
require dir + 'character/attribute/numeric'
require dir + 'character/attribute/decimal'
require dir + 'character/attribute/float'
require dir + 'character/attribute/integer'
require dir + 'character/attribute/string'
require dir + 'character/attribute/time'
