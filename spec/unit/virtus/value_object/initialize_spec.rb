require 'spec_helper'

describe Virtus::ValueObject, '#initialize' do
  subject { described_class.new(attributes) }

  let(:described_class) do
    Class.new do
      include Virtus::ValueObject

      attribute :currency, String
      attribute :amount,   Integer
    end
  end

  let(:attributes) { Hash[:currency => 'USD', :amount => 1] }

  its(:currency) { should eql('USD') }
  its(:amount)   { should eql(1)     }
end
