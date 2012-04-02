require 'spec_helper'

describe Virtus::Coercion::Integer, '.to_integer' do
  subject { described_class.to_integer(value) }

  let(:value) { 1 }

  it { should be(value) }
end
