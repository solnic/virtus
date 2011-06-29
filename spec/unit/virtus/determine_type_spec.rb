require 'spec_helper'

describe Virtus, '.determine_type' do
  Virtus::Attribute.descendants.each do |attribute_class|

    context "with class #{attribute_class.inspect}" do
      subject { described_class.determine_type(attribute_class) }

      it 'returns the corresponding attribute class' do
        should be(attribute_class)
      end
    end

    primitive = attribute_class.primitive
    context "with primitive #{primitive.inspect}" do
      subject { described_class.determine_type(primitive) }

      it 'returns the corresponding attribute class' do
        should be(attribute_class)
      end
    end

    suffix = attribute_class.name['Virtus::Attribute::'.length..-1]
    context "with string #{suffix.inspect}" do
      subject { described_class.determine_type(suffix) }

      it 'returns the corresponding attribute class' do
        should be(attribute_class)
      end
    end
  end
end
