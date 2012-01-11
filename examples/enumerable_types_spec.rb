require './spec/spec_helper'

class PhoneNumber
  include Virtus

  attribute :number, String
end

class User
  include Virtus

  attribute :phone_numbers, Array[PhoneNumber]
end

describe User do
  it { should respond_to(:phone_numbers)  }
  it { should respond_to(:phone_numbers=) }

  let(:instance) { described_class.new(:phone_numbers => phone_numbers_attributes) }
  let(:phone_numbers_attributes) { [
    { :number => '212-555-1212' },
    { :number => '919-444-3265' },
  ] }

  describe '#phone_numbers' do
    describe 'first entry' do
      subject { instance.phone_numbers.first }

      it { should be_instance_of(PhoneNumber) }

      its(:number)  { should eql('212-555-1212') }
    end

    describe 'last entry' do
      subject { instance.phone_numbers.last }

      it { should be_instance_of(PhoneNumber) }

      its(:number)  { should eql('919-444-3265') }
    end
  end
end
