require 'spec_helper'

describe Virtus::Attribute::Object, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Virtus::Attribute::Array,   Virtus::Attribute::Boolean,
      Virtus::Attribute::Date,    Virtus::Attribute::DateTime,
      Virtus::Attribute::Numeric, Virtus::Attribute::Hash,
      Virtus::Attribute::String,  Virtus::Attribute::Time ]
  end

  it "should return all known attribute classes" do
    subject.should eql(known_descendants)
  end
end
