require './spec/spec_helper'

class City
  include Virtus

  attribute :name, String
end

class Address
  include Virtus

  attribute :street,  String
  attribute :zipcode, String
  attribute :city,    City
end

class User
  include Virtus

  attribute :name,    String
  attribute :address, Address
end

describe User do
  it { should respond_to(:address)  }
  it { should respond_to(:address=) }

  describe '#address' do
    subject { described_class.new(:address => address_attributes).address }

    let(:address_attributes) do
      { :street => 'Street 1/2', :zipcode => '12345', :city => { :name => 'NYC' } }
    end

    it { should be_instance_of(Address) }

    its(:street)  { should eql('Street 1/2')    }
    its(:zipcode) { should eql('12345')         }
    its(:city)    { should be_instance_of(City) }
  end
end
