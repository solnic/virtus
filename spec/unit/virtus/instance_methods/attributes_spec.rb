require 'spec_helper'

describe Virtus::InstanceMethods do
  let(:model) do
    Class.new do
      include Virtus

      attribute :name,  String
      attribute :age,   Integer
      attribute :email, String, :accessor => :private

      attr_accessor :non_attribute
    end
  end

  let(:attributes) { { :name => 'john', :age => 28 } }

  describe '#attributes' do
    subject { object.attributes }

    let(:object) { model.new(attributes) }

    it { should be_instance_of(Hash) }

    it { should eql(attributes) }
  end

  describe '#attributes=' do
    subject { object.attributes = attribute_values }

    let(:object) { model.new }

    context 'when given values for publicly writable attributes' do
      let(:attribute_values) { attributes }

      it { should be(attribute_values) }

      it 'sets all provided attribute values' do
        object.attributes.should eql(:age => nil, :name => nil)
        subject
        object.attributes.should eql(attributes)
      end
    end

    context 'when given string keys for attributes' do
      let(:attribute_values) { { 'name' => 'john', 'age' => 28 } }

      it { should be(attribute_values) }

      it 'sets values for publicly accessible attributes' do
        object.attributes.should eql(:age => nil, :name => nil)
        subject
        object.attributes.should eql(attributes)
      end
    end

    context 'when given values for privately writable attributes' do
      let(:attribute_values) { attributes.merge(:email => 'john@domain.tld') }

      it { should be(attribute_values) }

      it 'only sets values for publicly accessible attributes' do
        object.attributes.should eql(:age => nil, :name => nil)
        subject
        object.attributes.should eql(attributes)
      end
    end

    context 'when given values for non-attribute setters' do
      let(:attribute_values) { attributes.merge(:non_attribute => 'foobar') }

      it { should be(attribute_values) }

      it 'sets values for publicly accessible attributes' do
        object.attributes.should eql(:age => nil, :name => nil)
        subject
        object.attributes.should eql(attributes)
      end

      it 'silently ignores publicly accessible non-Virtus attributes' do
        expect { subject }.to_not change { object.non_attribute }
      end
    end

    context "when given values that don't correspond to attributes" do
      let(:attribute_values) { attributes.merge(:quux => 'foobar') }

      it { should be(attribute_values) }

      it 'sets values for publicly accessible attributes' do
        object.attributes.should eql(:age => nil, :name => nil)
        subject
        object.attributes.should eql(attributes)
      end

      it 'silently ignores non-attribute keys' do
        expect { subject }.to_not raise_exception
      end
    end
  end
end
