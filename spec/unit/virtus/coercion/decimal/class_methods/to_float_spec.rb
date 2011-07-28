require 'spec_helper'

describe Virtus::Coercion::Decimal, '.to_float' do
  subject { object.to_float(big_decimal) }

  let(:object)      { described_class   }
  let(:big_decimal) { BigDecimal('1.0') }

  it { should be_instance_of(Float) }

  it { should eql(1.0) }
end
