require 'spec_helper'

describe Virtus::Attributes::Boolean do
  it_should_behave_like "Dirty Trackable Attribute" do
    let(:attribute_name)        { :is_admin }
    let(:attribute_value)       { true }
    let(:attribute_value_other) { '1' }
  end
end
