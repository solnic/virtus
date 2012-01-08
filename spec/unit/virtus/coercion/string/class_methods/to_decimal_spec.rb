require 'spec_helper'

describe Virtus::Coercion::String, '.to_decimal' do
  subject { object.to_decimal(string) }

  let(:object) { described_class }

  {
    '1'       => BigDecimal('1.0'),
    '+1'      => BigDecimal('1.0'),
    '-1'      => BigDecimal('-1.0'),
    '1.0'     => BigDecimal('1.0'),
    '1.0e+1'  => BigDecimal('10.0'),
    '1.0e-1'  => BigDecimal('0.1'),
    '1.0E+1'  => BigDecimal('10.0'),
    '1.0E-1'  => BigDecimal('0.1'),
    '+1.0'    => BigDecimal('1.0'),
    '+1.0e+1' => BigDecimal('10.0'),
    '+1.0e-1' => BigDecimal('0.1'),
    '+1.0E+1' => BigDecimal('10.0'),
    '+1.0E-1' => BigDecimal('0.1'),
    '-1.0'    => BigDecimal('-1.0'),
    '-1.0e+1' => BigDecimal('-10.0'),
    '-1.0e-1' => BigDecimal('-0.1'),
    '-1.0E+1' => BigDecimal('-10.0'),
    '-1.0E-1' => BigDecimal('-0.1'),
    '.1'      => BigDecimal('0.1'),
    '.1e+1'   => BigDecimal('1.0'),
    '.1e-1'   => BigDecimal('0.01'),
    '.1E+1'   => BigDecimal('1.0'),
    '.1E-1'   => BigDecimal('0.01'),
  }.each do |value, expected|
    context "with #{value.inspect}" do
      let(:string) { value }

      it { should be_instance_of(BigDecimal) }

      it { should eql(expected) }
    end
  end

  context 'with an invalid decimal string' do
    let(:string) { 'non-decimal' }

    it { should equal(string) }
  end
end
