require 'spec_helper'

describe Virtus::Attributes::Integer do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :age }
    let(:attribute_value)       { 28 }
    let(:attribute_value_other) { "28" }
  end
end
