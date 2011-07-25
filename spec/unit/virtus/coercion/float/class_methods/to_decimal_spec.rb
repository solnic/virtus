require 'spec_helper'

describe Virtus::Coercion::Float, '.to_decimal' do
  subject { object.to_decimal(float) }

  let(:object) { described_class }
  let(:float)  { 1.0             }

  it { should be_instance_of(BigDecimal) }

  it { should eql(BigDecimal('1.0')) }
end
