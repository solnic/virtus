require 'spec_helper'

describe Virtus::Typecast::Float, '.to_d' do
  subject { object.to_d(float) }

  let(:object) { described_class }
  let(:float)  { 1.0             }

  it { should be_instance_of(BigDecimal) }

  it { should eql(BigDecimal('1.0')) }
end
