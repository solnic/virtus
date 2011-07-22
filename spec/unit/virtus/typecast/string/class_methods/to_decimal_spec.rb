require 'spec_helper'

describe Virtus::Typecast::String, '.to_decimal' do
  subject { described_class.to_decimal(string) }

  let(:string)  { '1.0' }
  let(:decimal) { BigDecimal('1.0') }

  it { should == decimal }
end
