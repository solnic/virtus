require 'spec_helper'

describe Virtus::AttributeSet, '#each' do
  let(:name)       { :name                                   }
  let(:attribute)  { mock('Attribute', :name => name)        }
  let(:attributes) { [ attribute ]                           }
  let(:parent)     { described_class.new                     }
  let(:object)     { described_class.new(attributes, parent) }
  let(:yields)     { Set[]                                   }

  context 'with no block' do
    subject { object.each }

    it { should be_instance_of(to_enum.class) }

    it 'yields the expected attributes' do
      subject.to_a.should eql(object.to_a)
    end
  end

  context 'with a block' do
    subject { object.each { |attribute| yields << attribute } }

    context 'when the parent has no attributes' do
      it { should equal(object) }

      it 'yields the expected attributes' do
        expect { subject }.to change { yields.dup }.
          from(Set[]).
          to(attributes.to_set)
      end
    end

    context 'when the parent has attributes that are not duplicates' do
      let(:parent_attribute) { mock('Parent Attribute', :name => :parent_name) }
      let(:parent)           { described_class.new([ parent_attribute ])       }

      it { should equal(object) }

      it 'yields the expected attributes' do
        expect { subject }.to change { yields.dup }.
          from(Set[]).
          to(Set[ attribute, parent_attribute ])
      end
    end

    context 'when the parent has attributes that are duplicates' do
      let(:parent_attribute) { mock('Parent Attribute', :name => name)   }
      let(:parent)           { described_class.new([ parent_attribute ]) }

      it { should equal(object) }

      it 'yields the expected attributes' do
        expect { subject }.to change { yields.dup }.
          from(Set[]).
          to(Set[ attribute ])
      end
    end
  end
end
