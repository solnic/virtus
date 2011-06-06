require 'spec_helper'

describe Virtus::Attributes::Attribute, '#typecast' do
  let(:attribute_class) do
    Class.new(Virtus::Attributes::Integer) do
      def typecast(value, object)
        super + 1
      end
    end
  end

  let(:model) do
    model = Class.new do
      include Virtus
    end
    model.attribute(:count, attribute_class)
    model
  end

  let(:object) do
    model.new
  end

  context 'when overridden' do
    let(:input_value)  { 1 }
    let(:output_value) { 2   }

    before do
      object.count = input_value
    end

    it "peforms custom typecasting" do
      object.count.should eql(output_value)
    end
  end
end
