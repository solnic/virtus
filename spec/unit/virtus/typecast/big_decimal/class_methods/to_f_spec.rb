require 'spec_helper'

describe Virtus::Typecast::BigDecimal, '.to_f' do
  subject { object.to_f(big_decimal) }

  let(:object)      { described_class   }
  let(:big_decimal) { BigDecimal('1.0') }

  it { should be_instance_of(Float) }

  it { should eql(1.0) }
end
