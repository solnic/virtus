require 'spec_helper'

describe Virtus::AttributeSet, '#reset' do
  subject { object.reset }

  let(:name)       { :name                                   }
  let(:attribute)  { mock('Attribute', :name => name)        }
  let(:attributes) { [ attribute ]                           }
  let(:object)     { described_class.new(parent, attributes) }

  before { attribute.stub(:define_accessor_methods) }

  context 'when the parent has no attributes' do
    let(:parent) { described_class.new }

    it { should equal(object) }

    its(:to_set) { should == Set[ attribute ] }
  end

  context 'when the parent has attributes that are not duplicates' do
    let(:parent_attribute) { mock('Parent Attribute', :name => :parent_name) }
    let(:parent)           { described_class.new([ parent_attribute ])       }

    it { should equal(object) }

    its(:to_set) { should == Set[ attribute, parent_attribute ] }
  end

  context 'when the parent has attributes that are duplicates' do
    let(:parent_attribute) { mock('Parent Attribute', :name => name)   }
    let(:parent)           { described_class.new([ parent_attribute ]) }

    it { should equal(object) }

    its(:to_set) { should == Set[ attribute ] }
  end

  context 'when the parent has changed' do
    let(:parent_attribute) { mock('Parent Attribute', :name => :parent_name) }
    let(:parent)           { described_class.new([ parent_attribute ])       }
    let(:new_attribute)    { mock('New Attribute', :name => :parent_name)    }

    before { new_attribute.stub(:define_accessor_methods) }

    it { should equal(object) }

    it 'includes changes from the parent' do
      expect { parent << new_attribute; subject }.to change { object.to_set }.
        from(Set[ attribute, parent_attribute ]).
        to(Set[ attribute, new_attribute ])
    end
  end

  context 'when the parent is nil' do
    let(:parent) { nil }

    it { should equal(object) }

    it 'includes changes from the parent' do
      expect { subject }.to_not change { object.to_set }
    end
  end
end
