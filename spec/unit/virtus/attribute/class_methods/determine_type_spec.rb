require 'spec_helper'

describe Virtus::Attribute, '.determine_type' do
  let(:object) { described_class }

  described_class.descendants.each do |attribute_class|
    context "with class #{attribute_class.inspect}" do
      subject { object.determine_type(attribute_class) }

      it 'returns the corresponding attribute class' do
        should be(attribute_class)
      end
    end

    primitive = attribute_class.primitive
    context "with primitive #{primitive.inspect}" do
      subject { object.determine_type(primitive) }

      it 'returns the corresponding attribute class' do
        should be(attribute_class)
      end
    end

    string = attribute_class.name['Virtus::Attribute::'.length..-1]
    context "with string #{string.inspect}" do
      subject { object.determine_type(string) }

      it 'returns the corresponding attribute class' do
        should be(attribute_class)
      end
    end
  end

  context 'when the primitive defaults to Object' do
    subject { object.determine_type(primitive) }

    let(:primitive) { Class.new }

    it { should equal(Virtus::Attribute::Object) }
  end

  context 'when the string does not map to an Attribute' do
    subject { object.determine_type(string) }

    let(:string) { 'Unknown' }

    it { should be_nil }
  end
end
