require 'spec_helper'

describe Virtus::Coercion::String, '.to_integer' do
  subject { described_class.to_integer(string) }

  min_float = Float::MIN
  max_float = (Float::MAX / 10).to_s.to_f  # largest float that can be parsed

  {
    '1'            => 1,
    '+1'           => 1,
    '-1'           => -1,
    '1.0'          => 1,
    '1.0e+1'       => 10,
    '1.0e-1'       => 0,
    '1.0E+1'       => 10,
    '1.0E-1'       => 0,
    '+1.0'         => 1,
    '+1.0e+1'      => 10,
    '+1.0e-1'      => 0,
    '+1.0E+1'      => 10,
    '+1.0E-1'      => 0,
    '-1.0'         => -1,
    '-1.0e+1'      => -10,
    '-1.0e-1'      => 0,
    '-1.0E+1'      => -10,
    '-1.0E-1'      => 0,
    '.1'           => 0,
    '.1e+1'        => 1,
    '.1e-1'        => 0,
    '.1E+1'        => 1,
    '.1E-1'        => 0,
    '1e1'          => 10,
    '1E+1'         => 10,
    '+1e-1'        => 0,
    '-1E1'         => -10,
    '-1e-1'        => 0,
    min_float.to_s => min_float.to_i,
    max_float.to_s => max_float.to_i,
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

  context 'when integer string is big' do
    let(:string) { '334490140000101135' }

    it { should == 334490140000101135  }
  end

  context 'string starts with e' do
    let(:string) { 'e1' }

    # In further version it will raise exception
    it { should == 'e1' }
  end
end
