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
  let(:equivalent) { class_under_test.new(attribute_values) }
  subject { class_under_test.new(attribute_values) }

  describe 'initialization' do
    it 'sets the attribute values provided to Class.new' do
      class_under_test.new(:latitude => 10000.001).latitude.should == 10000.001
      subject.latitude.should eql(attribute_values[:latitude])
    end
  end

  describe 'writer visibility' do
    it 'attributes are configured for private writers' do
      class_under_test.attributes[:latitude].writer_visibility.should  == :private
      class_under_test.attributes[:longitude].writer_visibility.should == :private
    end

    it 'writer methods are set to private' do
      private_methods = class_under_test.private_instance_methods
      private_methods.map! { |m| m.to_s }
      private_methods.should include('latitude=', 'longitude=')
    end

    it 'attempts to call attribute writer methods raises NameError' do
      expect { subject.latitude  = 5.0 }.to raise_exception(NameError)
      expect { subject.longitude = 5.0 }.to raise_exception(NameError)
    end
  end

  describe 'equality' do
    it '#== returns true for different objects with the same state' do
      subject.should == equivalent
    end

    it '#eql? returns true for different objects with the same state' do
      subject.should eql(equivalent)
    end

    it '#equal? returns false for different objects with the same state' do
      subject.should_not equal(equivalent)
    end

    it '#hash returns the same value for different objects with the same state' do
      subject.hash.should eql(equivalent.hash)
    end
  end

  describe '#inspect' do
    it 'includes the class name and attribute values' do
      subject.inspect.should == '#<GeoLocation latitude=10.0 longitude=20.0>'
    end
  end
end
