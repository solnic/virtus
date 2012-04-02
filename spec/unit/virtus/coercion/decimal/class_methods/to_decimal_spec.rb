require 'spec_helper'

describe Virtus::Coercion::Decimal, '.to_decimal' do
  subject { described_class.to_decimal(value) }

  let(:value) { BigDecimal('1.0') }

  it { should be(value) }
end
