require 'spec_helper'

describe Virtus::InstanceMethods, '#attribute_set' do
  let(:described_class) do
    Class.new do
      include Virtus
      attribute :name, String
    end
  end

  let(:object) do
    described_class.new
  end

  let(:value) do
    'john'
  end

  before do
    object.attribute_set(:name, value)
  end

  it "returns the value" do
    object.attribute_set(:name, value).should == value
  end

  it "sets value of an attribute" do
    object.name.should == value
  end
end
