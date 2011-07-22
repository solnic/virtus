require 'spec_helper'

describe Virtus::Typecast::String, '.to_integer' do
  subject { described_class.to_integer(string) }

  let(:string)  { '1.0' }
  let(:integer) { 1 }

  it { should == integer }
end
