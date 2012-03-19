require 'spec_helper'

describe Virtus::Coercion::Float, '.to_float' do
  subject { described_class.to_float(value) }

  let(:value) { mock('value') }

  it { should be(value) }
end

