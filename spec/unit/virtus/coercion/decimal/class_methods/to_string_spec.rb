require 'spec_helper'

describe Virtus::Coercion::Decimal, '.to_string' do
  subject { object.to_string(big_decimal) }

  let(:object)      { described_class   }
  let(:big_decimal) { BigDecimal('1.0') }

  it { should be_instance_of(String) }

  it { should eql('1.0') }
end
