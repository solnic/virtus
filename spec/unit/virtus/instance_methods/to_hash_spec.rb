require 'spec_helper'

describe Virtus::InstanceMethods, '#to_hash' do
  subject { object.to_hash }

  class Address
    include Virtus

    attribute :street,  String
    attribute :city,    String
  end

  class Person
    include Virtus

    attribute :name,    String
    attribute :age,     Integer
    attribute :email,   String, :accessor => :private
    attribute :address, Address
  end

  let(:model)        { Person                          }
  let(:child_record) { Address                         }

  let(:address)    { { :street => "Sunshinestr.", :city => "Berlin" } }
  let(:object)     { model.new(attributes)                            }

  let(:attributes) { { :name => 'john', :age => 28, :address => child_record } }

  it { should be_instance_of(Hash) }

  it 'returns attributes' do
    should eql(attributes)
  end
end
