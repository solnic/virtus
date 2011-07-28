require 'spec_helper'

describe Virtus::Coercion::Decimal, '.to_integer' do
  subject { object.to_integer(big_decimal) }

  let(:object)      { described_class   }
  let(:big_decimal) { BigDecimal('1.0') }

  it { should be_kind_of(Integer) }

  it { should eql(1) }
end
