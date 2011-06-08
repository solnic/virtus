require 'spec_helper'

describe Virtus::Attribute do
  describe '#typecast_to_primitive' do
    let(:attribute) { Virtus::Attribute.new(:name) }
    let(:value)     { 'value' }

    it "returns original value" do
      attribute.typecast_to_primitive(value).should eql(value)
    end
  end
end
