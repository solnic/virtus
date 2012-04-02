require 'spec_helper'

describe Virtus::TypeLookup, '.extended' do
  let(:type) { Class.new { extend Virtus::TypeLookup } }

  it 'sets type_lookup_catch ivar' do
    type.instance_variable_get('@type_lookup_cache').should eql({})
  end
end
