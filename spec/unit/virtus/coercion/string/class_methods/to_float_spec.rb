require 'spec_helper'

describe Virtus::Coercion::String, '.to_float' do
  subject { described_class.to_float(string) }

  {
    '1'    => 1.0,
    '+1'   => 1.0,
    '-1'   => -1.0,
    '1.0'  => 1.0,
    '+1.0' => 1.0,
    '-1.0' => -1.0,
    '.1'   => 0.1,
  }.each do |value, expected|
    context "with #{value.inspect}" do
      let(:string) { value }

      it { should be_instance_of(Float) }

      it { should eql(expected) }
    end
  end

  context 'with an invalid float string' do
    let(:string) { 'non-float' }

    it { should equal(string) }
  end
end
