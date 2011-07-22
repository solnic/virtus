require 'spec_helper'

describe Virtus::Typecast::String, '.to_boolean' do
  subject { described_class.to_boolean(string) }

  described_class::TRUE_VALUES.each do |value|
    context "with #{value.inspect}" do
      let(:string) { value }
      it { should be(true) }
    end
  end

  described_class::FALSE_VALUES.each do |value|
    context "with #{value.inspect}" do
      let(:string) { value }
      it { should be(false) }
    end
  end

  context 'with an unknown string' do
    let(:string) { 'something' }
    it { should == string }
  end
end
