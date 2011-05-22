require 'spec_helper'

describe Virtus::Attributes::DateTime do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :created_at }
    let(:attribute_value)       { DateTime.now }
    let(:attribute_value_other) { DateTime.now.to_s }
  end
end
