require 'spec_helper'

describe Virtus::Attributes::Float do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :score }
    let(:attribute_value)       { 12.34 }
    let(:attribute_value_other) { "12.34" }
  end
end
