require 'spec_helper'

describe Virtus::Attributes::Attribute do
  describe '#typecast_to_primitive' do
    let(:model)     { Class.new { include Virtus } }
    let(:attribute) { Virtus::Attributes::Attribute.new(:name, model) }
    let(:value)     { 'value' }

    it "returns original value" do
      attribute.typecast_to_primitive(value, model).should eql(value)
    end
  end
end
