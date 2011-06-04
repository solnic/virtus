require 'spec_helper'

describe Virtus::InstanceMethods, '#attribute_get' do
  let(:described_class) do
    Class.new do
      include Virtus
      attribute :name, String
    end
  end

  let(:object) do
    described_class.new(:name => value)
  end

  let(:value) do
    'john'
  end

  it "returns the value of an attribute" do
    object.attribute_get(:name).should == value
  end
end
