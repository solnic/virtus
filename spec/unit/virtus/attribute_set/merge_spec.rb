require 'spec_helper'

describe Virtus::AttributeSet, '#merge' do
  subject { object.merge(other) }

  let(:attributes) { []                                      }
  let(:parent)     { described_class.new                     }
  let(:object)     { described_class.new(parent, attributes) }
  let(:name)       { :name                                   }
  let(:other)      { [ attribute ]                           }

  before { attribute.stub(:define_accessor_methods) }

  context 'with a new attribute' do
    let(:attribute) { mock('Attribute', :name => name) }

    it { should equal(object) }

    it 'adds an attribute' do
      expect { subject }.to change { object.to_a }.
        from(attributes).
        to([ attribute ])
    end
  end

  context 'with a duplicate attribute' do
    let(:attributes) { [ mock('Attribute', :name => name) ] }
    let(:attribute)  { mock('Duplicate', :name => name)     }

    it { should equal(object) }

    it 'replaces the original attribute' do
      expect { subject }.to change { object.to_a }.
        from(attributes).
        to([ attribute ])
    end
  end
end
