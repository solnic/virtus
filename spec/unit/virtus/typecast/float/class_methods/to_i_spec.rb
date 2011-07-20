require 'spec_helper'

describe Virtus::Typecast::Float, '.to_i' do
  subject { object.to_i(float) }

  let(:object) { described_class }
  let(:float)  { 1.0             }

  it { should be_kind_of(Integer) }

  it { should eql(1) }
end
