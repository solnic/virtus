require 'spec_helper'

describe Virtus::Attribute do
  describe '#typecast' do
    let(:attribute) { Virtus::Attribute.new(:name) }
    let(:value)     { 'value' }

    it "returns original value" do
      attribute.typecast(value).should eql(value)
    end
  end
end
