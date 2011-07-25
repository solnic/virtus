require 'spec_helper'

describe Virtus::Coercion::Float, '.to_integer' do
  subject { object.to_integer(float) }

  let(:object) { described_class }
  let(:float)  { 1.0             }

  it { should be_kind_of(Integer) }

  it { should eql(1) }
end
