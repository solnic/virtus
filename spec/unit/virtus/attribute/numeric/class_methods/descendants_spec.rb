require 'spec_helper'

describe Virtus::Attribute::Numeric, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Virtus::Attribute::Decimal,
      Virtus::Attribute::Float,
      Virtus::Attribute::Integer ]
  end

  it "should return all known attribute classes" do
    subject.should eql(known_descendants)
  end
end
