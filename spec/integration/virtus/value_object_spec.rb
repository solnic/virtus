require 'spec_helper'

describe Virtus::ValueObject do
  let(:class_under_test) do
    Class.new do
      def self.name
        'GeoLocation'
      end

      include Virtus::ValueObject

      attribute :latitude,  Float
      attribute :longitude, Float
    end
  end

  let(:attribute_values) { { :latitude => 10.0, :longitude => 20.0 } }

  let(:instance_with_equal_state) { class_under_test.new(attribute_values) }

  let(:instance_with_different_state) do
    class_under_test.new(:latitude => attribute_values[:latitude])
  end

  subject { class_under_test.new(attribute_values) }

  describe 'initialization' do
    it 'sets the attribute values provided to Class.new' do
      expect(class_under_test.new(:latitude => 10000.001).latitude).to eq(10000.001)
      expect(subject.latitude).to eql(attribute_values[:latitude])
    end
  end

  describe 'writer visibility' do
    it 'attributes are configured for private writers' do
      expect(class_under_test.attribute_set[:latitude].public_reader?).to be(true)
      expect(class_under_test.attribute_set[:longitude].public_writer?).to be(false)
    end

    it 'writer methods are set to private' do
      private_methods = class_under_test.private_instance_methods
      private_methods.map! { |m| m.to_s }
      expect(private_methods).to include('latitude=', 'longitude=', 'attributes=')
    end

    it 'attempts to call attribute writer methods raises NameError' do
      expect { subject.latitude  = 5.0 }.to raise_exception(NameError)
      expect { subject.longitude = 5.0 }.to raise_exception(NameError)
    end
  end

  describe 'equality' do
    describe '#==' do
      it 'returns true for different objects with the same state' do
        expect(subject).to eq(instance_with_equal_state)
      end

      it 'returns false for different objects with different state' do
        expect(subject).not_to eq(instance_with_different_state)
      end
    end

    describe '#eql?' do
      it 'returns true for different objects with the same state' do
        expect(subject).to eql(instance_with_equal_state)
      end

      it 'returns false for different objects with different state' do
        expect(subject).not_to eql(instance_with_different_state)
      end
    end

    describe '#equal?' do
      it 'returns false for different objects with the same state' do
        expect(subject).not_to equal(instance_with_equal_state)
      end

      it 'returns false for different objects with different state' do
        expect(subject).not_to equal(instance_with_different_state)
      end
    end

    describe '#hash' do
      it 'returns the same value for different objects with the same state' do
        expect(subject.hash).to eql(instance_with_equal_state.hash)
      end

      it 'returns different values for different objects with different state' do
        expect(subject.hash).not_to eql(instance_with_different_state.hash)
      end
    end
  end

  describe '#inspect' do
    it 'includes the class name and attribute values' do
      expect(subject.inspect).to eq('#<GeoLocation latitude=10.0 longitude=20.0>')
    end
  end
end
