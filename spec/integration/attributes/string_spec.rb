require 'spec_helper'

describe Virtus::Attributes::String do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :email }
    let(:attribute_value)       { 'red john' }
    let(:attribute_value_other) { :'red john' }
  end
end
