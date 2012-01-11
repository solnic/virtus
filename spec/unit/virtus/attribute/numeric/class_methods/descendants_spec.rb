require 'spec_helper'

describe Virtus::Attribute::Numeric, '.descendants' do
  subject { described_class.descendants }

  let(:known_descendants) do
    [ Virtus::Attribute::Integer,
      Virtus::Attribute::Float,
      Virtus::Attribute::Decimal ]
  end

  it 'should return all known attribute classes' do
    subject.should eql(known_descendants)
  end
end
