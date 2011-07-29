require 'spec_helper'

describe Virtus::Attribute::Hash do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :settings }
    let(:attribute_value)       { Hash[:one => 1] }
    let(:attribute_value_other) { Hash[:two => 2] }
    let(:attribute_default)     { Hash.new }
  end
end
