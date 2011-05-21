require 'spec_helper'

describe Virtus::Attributes::Numeric, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Virtus::Attributes::Decimal,
      Virtus::Attributes::Float,
      Virtus::Attributes::Integer ]
  end

  it "should return all known attribute classes" do
    subject.should == known_descendants
  end
end
