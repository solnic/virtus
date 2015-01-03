require 'spec_helper'

describe Virtus::AttributeSet, '#merge' do
  subject { object.merge(other) }

  let(:parent) { described_class.new }
  let(:object) { described_class.new(parent, attributes) }
  let(:name)   { :name }
  let(:other)  { [attribute] }

  context 'with a new attribute' do
    let(:attributes) { [] }
    let(:attribute)  { Virtus::Attribute.build(String, :name => name) }

    it { is_expected.to equal(object) }

    it 'adds an attribute' do
      expect { subject }.to change { object.to_a }.from(attributes).to([attribute])
    end
  end

  context 'with a duplicate attribute' do
    let(:attributes) { [Virtus::Attribute.build(String, :name => name)] }
    let(:attribute)  { Virtus::Attribute.build(String, :name => name) }

    it { is_expected.to equal(object) }

    it 'replaces the original attribute' do
      expect { subject }.to change { object.to_a }.from(attributes).to([attribute])
    end
  end
end
