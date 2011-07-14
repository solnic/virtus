require 'spec_helper'

describe Virtus::Attribute, '#set' do
  let(:attribute_class) do
    Class.new(Virtus::Attribute::Integer) do
      def set(instance, value)
        super(instance, typecast(value) + 1) unless value.nil?
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
    let(:output_value) { 2 }

    before do
      object.count = input_value
    end

    subject { object }

    its(:count) { should eql(output_value) }
  end
end
