require 'spec_helper'

describe Virtus::Attributes::Time do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :birthday }
    let(:attribute_value)       { Time.now }
    let(:attribute_value_other) { Time.now.to_s }
  end
end
