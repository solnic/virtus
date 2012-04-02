require 'spec_helper'

describe Virtus::Coercion::String, '.to_symbol' do
  subject { described_class.to_symbol(value) }

  let(:value) { 'value' }

  it { should be(:value) }
end
