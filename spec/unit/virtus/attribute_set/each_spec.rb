require 'spec_helper'

describe Virtus::AttributeSet, '#each' do
  let(:name)       { :name                                   }
  let(:attribute)  { Virtus::Attribute.build(String, :name => :name) }
  let(:attributes) { [ attribute ]                           }
  let(:parent)     { described_class.new                     }
  let(:object)     { described_class.new(parent, attributes) }
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
      let(:parent_attribute) { Virtus::Attribute.build(String, :name => :parent_name) }
      let(:parent)           { described_class.new([ parent_attribute ])       }

      it { should equal(object) }

      it 'yields the expected attributes' do
        expect { subject }.to change { yields.dup }.
          from(Set[]).
          to(Set[ attribute, parent_attribute ])
      end
    end

    context 'when the parent has attributes that are duplicates' do
      let(:parent_attribute) { Virtus::Attribute.build(String, :name => name) }
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
