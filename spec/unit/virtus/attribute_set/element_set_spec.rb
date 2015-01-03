require 'spec_helper'

describe Virtus::AttributeSet, '#[]=' do
  subject { object[name] = attribute }

  let(:attributes) { []                                      }
  let(:parent)     { described_class.new                     }
  let(:object)     { described_class.new(parent, attributes) }
  let(:name)       { :name                                   }

  context 'with a new attribute' do
    let(:attribute) { Virtus::Attribute.build(String, :name => name) }

    it { is_expected.to equal(attribute) }

    it 'adds an attribute' do
      expect { subject }.to change { object.to_a }.from(attributes).to([ attribute ])
    end

    it 'allows #[] to access the attribute with a symbol' do
      expect { subject }.to change { object['name'] }.from(nil).to(attribute)
    end

    it 'allows #[] to access the attribute with a string' do
      expect { subject }.to change { object[:name] }.from(nil).to(attribute)
    end

    it 'allows #reset to track overridden attributes' do
      expect { subject }.to change { object.reset.to_a }.from(attributes).to([ attribute ])
    end
  end

  context 'with a duplicate attribute' do
    let(:original)   { Virtus::Attribute.build(String, :name => name) }
    let(:attributes) { [ original ] }
    let(:attribute)  { Virtus::Attribute.build(String, :name => name) }

    it { is_expected.to equal(attribute) }

    it 'replaces the original attribute' do
      expect { subject }.to change { object.to_a }.from(attributes).to([ attribute ])
    end

    it 'allows #[] to access the attribute with a symbol' do
      expect { subject }.to change { object['name'] }.from(original).to(attribute)
    end

    it 'allows #[] to access the attribute with a string' do
      expect { subject }.to change { object[:name] }.from(original).to(attribute)
    end

    it 'allows #reset to track overridden attributes' do
      expect { subject }.to change { object.reset.to_a }.from(attributes).to([ attribute ])
    end
  end
end
