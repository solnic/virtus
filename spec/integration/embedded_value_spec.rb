require 'spec_helper'

describe 'embedded values' do
  before do
    module Examples
      class City
        include Virtus.model

        attribute :name, String
      end

      class Address
        include Virtus.model

        attribute :street,  String
        attribute :zipcode, String
        attribute :city,    City
      end

      class User
        include Virtus.model

        attribute :name,    String
        attribute :address, Address
      end
    end
  end

  subject { Examples::User.new(:name => 'the guy',
                               :address => address_attributes) }
  let(:address_attributes) do
      { :street => 'Street 1/2', :zipcode => '12345', :city => { :name => 'NYC' } }
  end

  specify '#attributes returns instances of the embedded values' do
    subject.attributes.should == {
      :name => 'the guy',
      :address => subject.address
    }
  end

  specify 'allows you to pass a hash for the embedded value' do
    user = Examples::User.new
    user.address = address_attributes
    user.address.street.should == 'Street 1/2'
    user.address.zipcode.should == '12345'
    user.address.city.name.should == 'NYC'
  end

end
