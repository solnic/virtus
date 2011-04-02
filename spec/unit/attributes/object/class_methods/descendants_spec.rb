require 'spec_helper'

describe Character::Attributes::Object, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Character::Attributes::Boolean, Character::Attributes::Date,
      Character::Attributes::DateTime, Character::Attributes::Numeric,
      Character::Attributes::String, Character::Attributes::Time ]
  end

  it "should return all known attribute classes" do
    subject.should == known_descendants
  end
end
