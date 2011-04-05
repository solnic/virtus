require 'spec_helper'

describe Character::Attributes::Numeric, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Character::Attributes::Decimal,
      Character::Attributes::Float,
      Character::Attributes::Integer ]
  end

  it "should return all known attribute classes" do
    subject.should == known_descendants
  end
end
