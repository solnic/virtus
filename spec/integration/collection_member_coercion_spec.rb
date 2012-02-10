require 'spec_helper'

# TODO: refactor to make it inline with the new style of integration specs

class Address
  include Virtus

  attribute :address,     String
  attribute :locality,    String
  attribute :region,      String
  attribute :postal_code, String
end

class PhoneNumber
  include Virtus

  attribute :number, String
end

class User
  include Virtus

  attribute :phone_numbers, Array[PhoneNumber]
  attribute :addresses,     Set[Address]
end

describe User do
  it { should respond_to(:phone_numbers)  }
  it { should respond_to(:phone_numbers=) }
  it { should respond_to(:addresses)  }
  it { should respond_to(:addresses=) }

  let(:instance) do
    described_class.new(:phone_numbers => phone_numbers_attributes,
                        :addresses     => addresses_attributes)
  end

  let(:phone_numbers_attributes) { [
    { :number => '212-555-1212' },
    { :number => '919-444-3265' },
  ] }

  let(:addresses_attributes) { [
    { :address => '1234 Any St.', :locality => 'Anytown', :region => "DC", :postal_code => "21234" },
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

  describe '#addresses' do
    subject { instance.addresses.first }

    it { should be_instance_of(Address) }

    its(:address)     { should eql('1234 Any St.') }
    its(:locality)    { should eql('Anytown')      }
    its(:region)      { should eql('DC')           }
    its(:postal_code) { should eql('21234')        }
  end
end
