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
  it { is_expected.to respond_to(:phone_numbers)  }
  it { is_expected.to respond_to(:phone_numbers=) }
  it { is_expected.to respond_to(:addresses)  }
  it { is_expected.to respond_to(:addresses=) }

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

      it { is_expected.to be_instance_of(PhoneNumber) }

      describe '#number' do
        subject { super().number }
        it { is_expected.to eql('212-555-1212') }
      end
    end

    describe 'last entry' do
      subject { instance.phone_numbers.last }

      it { is_expected.to be_instance_of(PhoneNumber) }

      describe '#number' do
        subject { super().number }
        it { is_expected.to eql('919-444-3265') }
      end
    end
  end

  describe '#addresses' do
    subject { instance.addresses.first }

    it { is_expected.to be_instance_of(Address) }

    describe '#address' do
      subject { super().address }
      it { is_expected.to eql('1234 Any St.') }
    end

    describe '#locality' do
      subject { super().locality }
      it { is_expected.to eql('Anytown')      }
    end

    describe '#region' do
      subject { super().region }
      it { is_expected.to eql('DC')           }
    end

    describe '#postal_code' do
      subject { super().postal_code }
      it { is_expected.to eql('21234')        }
    end
  end
end
