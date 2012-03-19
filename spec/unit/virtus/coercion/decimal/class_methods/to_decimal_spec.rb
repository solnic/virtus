require 'spec_helper'

describe Virtus::Coercion::Decimal, '.to_decimal' do
  subject { described_class.to_decimal(value) }

  let(:value) { mock('value') }

  it { should be(value) }
end

