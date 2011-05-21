require 'spec_helper'

describe Virtus::Attributes::Object, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Virtus::Attributes::Boolean, Virtus::Attributes::Date,
      Virtus::Attributes::DateTime, Virtus::Attributes::Numeric,
      Virtus::Attributes::String, Virtus::Attributes::Time ]
  end

  it "should return all known attribute classes" do
    subject.should == known_descendants
  end
end
