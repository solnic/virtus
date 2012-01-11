require 'spec_helper'

describe Virtus::Attribute::Object, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Virtus::Attribute::EmbeddedValue,
      Virtus::Attribute::Time,    Virtus::Attribute::String,
      Virtus::Attribute::Integer, Virtus::Attribute::Hash,
      Virtus::Attribute::Float,   Virtus::Attribute::Decimal,
      Virtus::Attribute::Numeric, Virtus::Attribute::DateTime,
      Virtus::Attribute::Date,    Virtus::Attribute::Boolean,
      Virtus::Attribute::Array,   Virtus::Attribute::Class ]
  end

  it 'should return all known attribute classes' do
    subject.should eql(known_descendants)
  end
end
