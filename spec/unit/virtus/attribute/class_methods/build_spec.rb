require 'spec_helper'

describe Virtus::Attribute, '.build' do
  let(:object) { described_class }
  let(:name)   { :name           }
  let(:type)   { String          }

  context 'without options' do
    subject { object.build(name, type) }

    it { should be_instance_of(Virtus::Attribute::String) }

    its(:name) { should be(name) }

    its(:options) { should == Virtus::Attribute::String.options }
  end

  context 'with options' do
    subject { object.build(name, type, options) }

    let(:options) { {} }

    it { should be_instance_of(Virtus::Attribute::String) }

    its(:name) { should be(name) }

    its(:options) { should == Virtus::Attribute::String.options }
  end

  context 'without a type' do
    subject { object.build(name) }

    it { should be_instance_of(Virtus::Attribute::Object) }

    its(:name) { should be(name) }

    its(:options) { should == Virtus::Attribute::Object.options }
  end

  context 'with an invalid type' do
    subject { object.build(name, type) }

    let(:type) { 'test' }

    specify { expect { subject }.to raise_error(ArgumentError, '"test" does not map to an attribute type') }
  end
end
