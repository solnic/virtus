require 'spec_helper'

describe Virtus::Typecast::BigDecimal, '.to_i' do
  subject { object.to_i(big_decimal) }

  let(:object)      { described_class   }
  let(:big_decimal) { BigDecimal('1.0') }

  it { should be_kind_of(Integer) }

  it { should eql(1) }
end
