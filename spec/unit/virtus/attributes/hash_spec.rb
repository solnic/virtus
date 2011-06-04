require 'spec_helper'

describe Virtus::Attributes::Hash do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :settings }
    let(:attribute_value)       { Hash[:one => 1] }
    let(:attribute_value_other) { Hash[:two => 2] }
  end
end
