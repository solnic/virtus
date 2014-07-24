require 'spec_helper'

describe Virtus::AttributeSet, '#each' do
  subject(:attribute_set) { described_class.new(parent, attributes) }

  let(:name)       { :name }
  let(:attribute)  { Virtus::Attribute.build(String, :name => :name) }
  let(:attributes) { [ attribute ] }
  let(:parent)     { described_class.new }
  let(:yields)     { Set[] }

  context 'with no block' do
    it 'returns an enumerator when block is not provided' do
      expect(attribute_set.each).to be_kind_of(Enumerator)
    end

    it 'yields the expected attributes' do
      result = []
      attribute_set.each { |attribute| result << attribute }
      expect(result).to eql(attributes)
    end
  end

  context 'with a block' do
    subject { attribute_set.each { |attribute| yields << attribute } }

    context 'when the parent has no attributes' do
      it { should equal(attribute_set) }

      it 'yields the expected attributes' do
        expect { subject }.to change { yields.dup }.
          from(Set[]).
          to(attributes.to_set)
      end
    end

    context 'when the parent has attributes that are not duplicates' do
      let(:parent_attribute) { Virtus::Attribute.build(String, :name => :parent_name) }
      let(:parent)           { described_class.new([ parent_attribute ])       }

      it { should equal(attribute_set) }

      it 'yields the expected attributes' do
        result = []

        attribute_set.each { |attribute| result << attribute }

        expect(result).to eql([parent_attribute, attribute])
      end
    end

    context 'when the parent has attributes that are duplicates' do
      let(:parent_attribute) { Virtus::Attribute.build(String, :name => name) }
      let(:parent)           { described_class.new([ parent_attribute ]) }

      it { should equal(attribute_set) }

      it 'yields the expected attributes' do
        expect { subject }.to change { yields.dup }.
          from(Set[]).
          to(Set[ attribute ])
      end
    end
  end
end
