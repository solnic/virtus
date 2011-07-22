require 'spec_helper'

describe Virtus::Typecast::String, '.to_float' do
  subject { described_class.to_float(string) }

  let(:string) { '1' }
  let(:float)  { 1.0 }

  it { should == float }
end
