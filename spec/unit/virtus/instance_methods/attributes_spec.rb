require 'spec_helper'

describe Virtus::InstanceMethods do
  let(:model) do
    Class.new do
      include Virtus

      attribute :name,  String
      attribute :age,   Integer
      attribute :email, String, :accessor => :private

      attr_accessor :non_attribute

      def private_non_attribute_reader
        @private_non_attribute
      end

      private

      attr_accessor :private_non_attribute
    end
  end

  let(:hash_object) do
    Class.new do
      def to_hash
        {:age => 5}
      end
    end.new
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

      it 'sets publicly accessible non-Virtus attributes' do
        expect { subject }.to change { object.non_attribute }
      end

      it 'silently ignores private non-Virtus attributes' do
        expect { subject }.to_not change { object.private_non_attribute_reader }
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

    context "when given values respond_to?(:to_hash)" do
      let(:attribute_values) { hash_object }

      it 'sets attributes' do
        subject
        object.age.should == 5
      end
    end

    context "when given values does not respond_to?(:to_hash)" do
      let(:attribute_values) { '' }

      it 'raises an exception' do
        expect {
          subject
        }.to raise_error(NoMethodError, 'Expected "" to respond to #to_hash')
      end
    end
  end
end
