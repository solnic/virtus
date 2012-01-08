require 'spec_helper'

describe Virtus::Coercion::String, '.to_integer' do
  subject { described_class.to_integer(string) }

  {
    '1'       => 1,
    '+1'      => 1,
    '-1'      => -1,
    '1.0'     => 1,
    '1.0e+1'  => 10,
    '1.0e-1'  => 0,
    '1.0E+1'  => 10,
    '1.0E-1'  => 0,
    '+1.0'    => 1,
    '+1.0e+1' => 10,
    '+1.0e-1' => 0,
    '+1.0E+1' => 10,
    '+1.0E-1' => 0,
    '-1.0'    => -1,
    '-1.0e+1' => -10,
    '-1.0e-1' => 0,
    '-1.0E+1' => -10,
    '-1.0E-1' => 0,
    '.1'      => 0,
    '.1e+1'   => 1,
    '.1e-1'   => 0,
    '.1E+1'   => 1,
    '.1E-1'   => 0,
  }.each do |value, expected|
    context "with #{value.inspect}" do
      let(:string) { value }

      it { should be_kind_of(Integer) }

      it { should eql(expected) }
    end
  end

  context 'with an invalid integer string' do
    let(:string) { 'non-integer' }

    it { should equal(string) }
  end
end
