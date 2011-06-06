require 'spec_helper'

describe Virtus::Attributes::Object, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Virtus::Attributes::Array,   Virtus::Attributes::Boolean,
      Virtus::Attributes::Date,    Virtus::Attributes::DateTime,
      Virtus::Attributes::Numeric, Virtus::Attributes::Hash,
      Virtus::Attributes::String,  Virtus::Attributes::Time ]
  end

  it "should return all known attribute classes" do
    subject.should eql(known_descendants)
  end
end
