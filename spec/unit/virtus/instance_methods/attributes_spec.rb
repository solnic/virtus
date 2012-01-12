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

  let(:object)     { model.new(attributes)           }
  let(:attributes) { { :name => 'john', :age => 28 } }

  describe '#attributes' do
    subject { object.attributes }

    it { should be_instance_of(Hash) }

    it { should eql(attributes) }
  end

  describe '#attributes=' do
    subject { object.attributes = attribute_values; object }

    let(:object) { model.new({}) }

    context 'when given values for publicly writable attributes' do
      let(:attribute_values) { attributes }

      it 'sets all provided attribute values' do
        subject.attributes.should eql(attributes)
      end
    end

    context 'when given string keys for attributes' do
      let(:attribute_values) do
        { 'name' => 'john', 'age' => 28 }
      end

      it 'sets values for publicly accessible attributes' do
        subject.attributes.should eql(attributes)
      end
    end

    context 'when given values for privately writable attributes' do
      let(:attribute_values) { attributes.merge(:email => 'john@domain.tld') }

      it 'only sets values for publicly accessible attributes' do
        subject.attributes.should eql(attributes)
      end
    end

    context 'when given values for non-attribute setters' do
      let(:attribute_values) { attributes.merge(:non_attribute => 'foobar') }

      it 'sets values for publicly accessible attributes' do
        subject.attributes.should eql(attributes)
      end

      it 'silently ignores publicly accessible non-Virtus attributes' do
        subject.non_attribute.should be_nil
      end
    end

    context "when given values that don't correspond to attributes" do
      let(:attribute_values) { attributes.merge(:quux => 'foobar') }

      it 'sets values for publicly accessible attributes' do
        subject.attributes.should eql(attributes)
      end

      it 'silently ignores non-attribute keys' do
        expect { subject }.to_not raise_exception
      end
    end
  end
end
